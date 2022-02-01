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
            
            cell.setupCell(comicTitle: title, comicNumber: comicNumber)
            
            return cell
        }
        return dataSource
    }
    
    func updateCollectionView() {
        //First build a dictionary that maps each section to its associated array of items
        
        let itemsResult = viewModel.items()
        
        var snapshot = NSDiffableDataSourceSnapshot<ComicBrowserViewModel.Section, ComicBrowserViewModel.Item>()
        snapshot.appendSections([ComicBrowserViewModel.Section.latestComic, ComicBrowserViewModel.Section.comics])
        
        snapshot.appendItems([viewModel.model.latestComic!], toSection: .latestComic)
        snapshot.appendItems(viewModel.model.comics!, toSection: .comics)
        
        dataSource.apply(snapshot)
        
        
    }
}

extension ComicBrowserCollectionViewController: ComicBrowserViewModelDelegate {
    func itemsChanged() {
        updateCollectionView()
    }
}
