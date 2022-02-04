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
    @IBOutlet weak var comicNumberLabelContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        comicNumberLabelContainer.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        comicImageView.image = nil
    }
    
    func setupCell(comicTitle: String, comicNumber: Int, imageURL: URL) {
        comicTitleLabel.text = comicTitle
        comicNumberLabel.text = "#\(comicNumber)"
        ComicImageRequest(imageURL: imageURL).send { response in
            switch response {
            case .success(let image):
                DispatchQueue.main.async {
                    self.comicImageView.image = image
                }
            case .failure(let error):
                print("Unable to get image - \(error)")
            }
        }
    }
    
    func setupCell(comicTitle: String, comicNumber: Int, imageData: Data?) {
        comicTitleLabel.text = comicTitle
        comicNumberLabel.text = "#\(comicNumber)"
        
        if let imageData = imageData {
            let rebornImg = imageData.description.imageFromBase64
            comicImageView.image = rebornImg
        } else {
            comicImageView.image = UIImage(systemName: "nosign")
        }
        
    }
}
