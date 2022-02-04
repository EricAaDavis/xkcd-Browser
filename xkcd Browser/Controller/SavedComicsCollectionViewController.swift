//
//  SavedComicsCollectionViewController.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class SavedComicsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<String, StoredComic>
    
    var dataSource: DataSourceType!
    
    var selectedComic: StoredComic?
    
    func updateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<String, StoredComic>()
        
        let storedComicsToDisplay = SavedComicsManager.shared.getSavedComics()
        
        snapshot.appendSections(["Saved Comics"])
        snapshot.appendItems(storedComicsToDisplay)
        
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.shared.comicCellReuseIdentifier, for: indexPath) as! ComicCollectionViewCell
            
            let title = item.title
            let comicNumber = item.comicNumber
            
            cell.backgroundColor = UIColor(named: "xkcd color")
            cell.layer.cornerRadius = 20
            
            cell.setupCell(comicTitle: title, comicNumber: comicNumber, imageURL: item.img)
            
            return cell
        }
        return dataSource
    }
}
