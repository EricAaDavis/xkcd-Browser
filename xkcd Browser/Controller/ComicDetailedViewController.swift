//
//  ViewController.swift
//  xkcd Browser
//
//  Created by Eric Davis on 31/01/2022.
//

import UIKit

class ComicDetailedViewController: UIViewController {


    @IBOutlet weak var comicTitleLabel: UILabel!
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicNumberlabel: UILabel!
    @IBOutlet weak var altTextlabel: UILabel!
    @IBOutlet weak var transcriptTextlabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
        
    }

    
    let latestComicNumber = ComicBrowserViewModel.latestComicNumber
    var comic: Comic?
    var comicNumber: Int?
    
    func updateUI() {
        guard let comic = comic else { return }
        comicTitleLabel.text = comic.title
        comicNumberlabel.text = "#\(comic.number)"
        altTextlabel.text = comic.titleText == "" ? "No alt text" : comic.titleText
        transcriptTextlabel.text = comic.transcript == "" ? "No Transcript" : comic.transcript
        
        ComicImageRequest(imageURL: comic.img).send() { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.comicImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendComicRequest(for comicNumber: Int) {
        
    }
    
}

