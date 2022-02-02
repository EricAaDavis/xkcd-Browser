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
        
        //First we get the latest comic
        viewModel.getLatestComicWithPreviousTwenty()
        
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ComicBrowserViewModel.Section, ComicBrowserViewModel.Item>
    
    let viewModel = ComicBrowserViewModel()
    
    var dataSource: DataSourceType!
    
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
    
    
    var snapshot = NSDiffableDataSourceSnapshot<ComicBrowserViewModel.Section, ComicBrowserViewModel.Item>()
    
    func updateCollectionView() {
        snapshot.deleteAllItems()
        
        guard let latestComic = viewModel.model.latestComic,
              let comics = viewModel.model.comics else { return }
        
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
}

extension ComicBrowserCollectionViewController: ComicBrowserViewModelDelegate {
    func itemsChanged() {
        updateCollectionView()
    }
}
