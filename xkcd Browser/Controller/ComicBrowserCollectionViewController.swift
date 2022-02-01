//
//  ComicBrowserCollectionViewController.swift
//  xkcd Browser
//
//  Created by Eric Davis on 01/02/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class ComicBrowserCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)


        //First we get the latest comic
        viewModel.getLatestComicWithPreviousTwenty()
        
    }
    
    let viewModel = ComicBrowserViewModel()
    
    
    func checkData() {
        viewModel.items()
    }
}

extension ComicBrowserCollectionViewController: ComicBrowserViewModelDelegate {
    func itemsChanged() {
        checkData()
    }
}
