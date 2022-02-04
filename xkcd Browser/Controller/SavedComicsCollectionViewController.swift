//
//  SavedComicsCollectionViewController.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class SavedComicsCollectionViewController: UICollectionViewController {

    typealias DataSourceType = UICollectionViewDiffableDataSource<String, StoredComic>
    
    var snapshot = NSDiffableDataSourceSnapshot<String, StoredComic>()
    
    var dataSource: DataSourceType!
    
    var selectedComic: StoredComic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SavedComicsManager.shared.delegate = self
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        updateCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedComic = snapshot.itemIdentifiers[indexPath.item]
        
        self.performSegue(withIdentifier: C.shared.detailedScreenSegueIdentifierFromSaved, sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.shared.detailedScreenSegueIdentifierFromSaved {
            if let destinationVC = segue.destination as? ComicDetailedViewController {
                destinationVC.storedComicDisplayed = selectedComic
            }
        }
    }

    func updateCollectionView() {
        let storedComicsToDisplay = SavedComicsManager.shared.getSavedComics()
        
        snapshot.deleteAllItems()
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
            
            cell.setupCell(comicTitle: title, comicNumber: comicNumber, imageData: item.image)
            
            return cell
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.45)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension SavedComicsCollectionViewController: SavedComicsManagerDelegate {
    func savedComicsUpdated() {
        updateCollectionView()
    }
}
