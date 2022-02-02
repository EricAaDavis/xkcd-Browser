//
//  ComicBrowserCollectionViewController.swift
//  xkcd Browser
//
//  Created by Eric Davis on 01/02/2022.
//

import UIKit

private let reuseIdentifier = "ComicCell"

class ComicBrowserCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self

        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        //First we get the latest comic plus previous comics based on numberOfItemsToFetch
        viewModel.getLatestComicWithNumberOfItemsToFetch()
        
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ComicBrowserViewModel.Section, ComicBrowserViewModel.Item>
    
    let viewModel = ComicBrowserViewModel()
    
    var dataSource: DataSourceType!
    
    var snapshot = NSDiffableDataSourceSnapshot<ComicBrowserViewModel.Section, ComicBrowserViewModel.Item>()
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ComicCollectionViewCell
            
            let title = item.title
            let comicNumber = String("#\(item.number)")
            cell.backgroundColor = .systemBlue
            cell.layer.cornerRadius = 15 
            cell.setupCell(comicTitle: title, comicNumber: comicNumber, imageURL: item.img)
            
            return cell
        }
        return dataSource
    }
    
    func updateCollectionView() {
        guard let latestComic = viewModel.model.latestComic,
              let comics = viewModel.model.comics else { return }
        
        
        snapshot.deleteAllItems()
        
        let sortedComics = comics.sorted { lhs, rhs in
            lhs.number > rhs.number
        }
        
        snapshot.appendSections([.latestComic, .comics])
        snapshot.appendItems([latestComic], toSection: .latestComic)
        snapshot.appendItems(sortedComics, toSection: .comics)
        dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            switch self.snapshot.sectionIdentifiers[sectionIndex]  {
            case .latestComic:
                let latesComicItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let latestComicItem = NSCollectionLayoutItem(layoutSize: latesComicItemSize)
                
                let latestComicGroupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .fractionalWidth(0.7)
                )
                let latestComicGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: latestComicGroupSize,
                    subitem: latestComicItem,
                    count: 1)
                
                
                let latestComicSection = NSCollectionLayoutSection(group: latestComicGroup)
                let spacing: CGFloat = 10
                latestComicSection.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: spacing
                )
                
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
                    heightDimension: .fractionalWidth(0.45)
                )
                let comicsGroup = NSCollectionLayoutGroup.horizontal (
                    layoutSize: comicsGroupSize,
                    subitem: comicsItem,
                    count: 2)
                
                comicsGroup.interItemSpacing = .fixed(spacing)
                
                let comicsSection = NSCollectionLayoutSection(group: comicsGroup)
                comicsSection.interGroupSpacing = spacing
                comicsSection.contentInsets = NSDirectionalEdgeInsets(
                    top: spacing,
                    leading: spacing,
                    bottom: spacing,
                    trailing: spacing
                )
                return comicsSection
            }
        }
        return layout
    }
    
    var perform = 0
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (viewModel.model.comics!.count - 4) {
            viewModel.getNextComics()
        }
//        if indexPath.item == (viewModel.model.comics!.count - 4) && perform == 0 {
//            print("perform new data request")
//            viewModel.getPreviousComicsForNumber(from: 2535, to: 2554)
//            perform = 1
//        } else if indexPath.item == (viewModel.model.comics!.count - 4) &&  perform == 1 {
//            viewModel.getPreviousComicsForNumber(from: 2515, to: 2534)
//            perform = 2
//        }
        
//        print(viewModel.model.comics?.count)
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(collectionView.indexPathsForVisibleItems)
//    }
    
}
extension ComicBrowserCollectionViewController: ComicBrowserViewModelDelegate {
    func itemsChanged() {
        updateCollectionView()
    }
}
