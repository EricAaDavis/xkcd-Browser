//
//  ComicBrowserCollectionViewController.swift
//  xkcd Browser
//
//  Created by Eric Davis on 01/02/2022.
//

import UIKit

private let latestComicSectionHeaderKind = "LatestComicKind"
private let detailedScreenSegueIdentifer = "ShowDetailedScreen"

class ComicBrowserCollectionViewController: UICollectionViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = ComicBrowserViewModel()
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ComicBrowserViewModel.Section, Comic>
    
    var dataSource: DataSourceType!
    
    var snapshot = NSDiffableDataSourceSnapshot<ComicBrowserViewModel.Section, Comic>()
    
    let searchController = UISearchController()
    
    var selectedComic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        //Seturp Search Controller
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.placeholder = "Search for comic by number"
        searchController.searchBar.keyboardType = .numberPad
        
        //Collection view setup
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(LatestComicSectionHeaderView.self, forSupplementaryViewOfKind: latestComicSectionHeaderKind, withReuseIdentifier: LatestComicSectionHeaderView.reuseIdentifier)
        
        viewModel.delegate = self
        
        //When the view loads we get the latest comic plus previous comics based on numberOfItemsToFetch
        viewModel.getLatestComicWithNumberOfItemsToFetch()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var itemIndex = indexPath.item

        if indexPath.section == 1 {
            itemIndex += 1
        }
        
        selectedComic = snapshot.itemIdentifiers[itemIndex]
        
        
        self.performSegue(withIdentifier: detailedScreenSegueIdentifer, sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailedScreenSegueIdentifer {
            if let destinationVC = segue.destination as? ComicDetailedViewController {
                destinationVC.currentComic = selectedComic
            }
        }
    }
    
    //Debouncing for the purpose of not sending an api request by every keystroke
    func updateSearchResults(for searchController: UISearchController) {
        let selector = #selector(fetchComicByNumber)
        
        //Prevents the call to the selector for the previous input
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: nil)
        
        //0.3 seconds is considered to be just a perfect delay
        perform(selector, with: nil, afterDelay: 0.3)
    }
    
    @objc func fetchComicByNumber() {
        guard let searchControllerText = searchController.searchBar.text else { return }
        if searchControllerText != "" {
            viewModel.getSpecificComicByNumber(numberString: searchControllerText)
        } else {
            viewModel.featuredComic = nil
        }
    }
    
    func updateCollectionView() {
        guard let latestComic = viewModel.model.latestComic,
              let comics = viewModel.model.comics else { return }
        
        snapshot.deleteAllItems()
        snapshot.appendSections([.featuredComic, .comics])
        
        let searchedComic = viewModel.featuredComic
        
        if searchedComic != nil {
            snapshot.appendItems([searchedComic!], toSection: .featuredComic)
            snapshot.appendItems([], toSection: .comics)
        } else {
            snapshot.appendItems([latestComic], toSection: .featuredComic)
            let sortedComics = comics.sorted { lhs, rhs in
                lhs.number > rhs.number
            }
            snapshot.appendItems(sortedComics, toSection: .comics)
        }
        
        dataSource.apply(snapshot)
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.shared.comicCellReuseIdentifier, for: indexPath) as! ComicCollectionViewCell
            
            let title = item.title
            let comicNumber = String("#\(item.number)")
            cell.backgroundColor = UIColor(named: "xkcd color")
            cell.layer.cornerRadius = 20
            cell.setupCell(comicTitle: title, comicNumber: comicNumber, imageURL: item.img)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: latestComicSectionHeaderKind, withReuseIdentifier: LatestComicSectionHeaderView.reuseIdentifier, for: indexPath) as! LatestComicSectionHeaderView
            
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .featuredComic:
                header.nameLabel.text = "Latest Comic"
                header.nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
            case .comics:
                header.nameLabel.text = "All Comics"
            }
            return header
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            switch self.snapshot.sectionIdentifiers[sectionIndex]  {
            case .featuredComic:
                let latesComicItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1))
                
                let latestComicItem = NSCollectionLayoutItem(layoutSize: latesComicItemSize)
                
                let latestComicGroupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.75),
                    heightDimension: .fractionalWidth(0.75))
                
                let latestComicGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: latestComicGroupSize,
                    subitem: latestComicItem,
                    count: 1)
                
                //Create the header layout
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(45))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: latestComicSectionHeaderKind, alignment: .top)
                sectionHeader.pinToVisibleBounds = true
                
                let latestComicSection = NSCollectionLayoutSection(group: latestComicGroup)
                let spacing: CGFloat = 10
                latestComicSection.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: 0,
                    bottom: spacing,
                    trailing: 0
                )
                
                latestComicSection.boundarySupplementaryItems = [sectionHeader]
                latestComicSection.orthogonalScrollingBehavior = .groupPagingCentered
                
                return latestComicSection
                
            case .comics:
                let spacing: CGFloat = 15
                
                let comicsItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let comicsItem = NSCollectionLayoutItem(layoutSize: comicsItemSize)
                
                let comicsGroupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.5)
                )
                let comicsGroup = NSCollectionLayoutGroup.horizontal (
                    layoutSize: comicsGroupSize,
                    subitem: comicsItem,
                    count: 2)
                
                comicsGroup.interItemSpacing = .fixed(spacing)
                comicsGroup.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: spacing,
                    bottom: 0,
                    trailing: spacing
                )
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: latestComicSectionHeaderKind, alignment: .top)
                sectionHeader.pinToVisibleBounds = true
                
                let comicsSection = NSCollectionLayoutSection(group: comicsGroup)
                comicsSection.interGroupSpacing = spacing
                comicsSection.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: 0,
                    bottom: spacing,
                    trailing: 0
                )
                
                comicsSection.boundarySupplementaryItems = [sectionHeader]
                
                return comicsSection
            }
        }
        return layout
    }
    
    //This function is used to fetch the next set of comics when the user scrolls to the last 4th cell
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewModel.model.comics!.count - 4) {
            viewModel.getNextComics()
        }
    }
}
extension ComicBrowserCollectionViewController: ComicBrowserViewModelDelegate {
    func itemsChanged() {
        updateCollectionView()
    }
}

