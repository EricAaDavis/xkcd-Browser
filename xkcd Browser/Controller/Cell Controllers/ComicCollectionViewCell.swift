//
//  ComicCollectionViewCell.swift
//  xkcd Browser
//
//  Created by Eric Davis on 01/02/2022.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var comicTitleLabel: UILabel!
    @IBOutlet weak var comicNumberLabel: UILabel!
    @IBOutlet weak var comicImageView: UIImageView!
    
    func setupCell(comicTitle: String, comicNumber: String, comicImage: UIImage) {
        comicTitleLabel.text = comicTitle
        comicNumberLabel.text = comicNumber
        comicImageView.image = comicImage
    }
    
}
