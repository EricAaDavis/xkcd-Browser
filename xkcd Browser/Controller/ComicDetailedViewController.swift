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
    @IBOutlet weak var nextComicButton: UIButton!
    @IBOutlet weak var previousComicButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    //Latest comic number is used to indicate to the user that there are no newer comics by disabling the next button
    let latestComicNumber = ComicBrowserViewModel.latestComicNumber
    
    //The comic currently displayed
    var currentComic: Comic?
    var currentComicNumber: Int? {
        currentComic?.number
    }
    
    func updateUI() {
        checkIfNext()
        guard let comic = currentComic else { return }
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
    
    //Checks wether there is a next comic or the first comic is displayed. If ither are true, disable the respectable button.
    func checkIfNext() {
        nextComicButton.isEnabled = true
        previousComicButton.isEnabled = true
        if currentComicNumber! == latestComicNumber! {
            nextComicButton.isEnabled = false
        } else if currentComicNumber! == 1 {
            previousComicButton.isEnabled = false
        }
    }
    
    func sendComicRequest(for comicNumber: Int) {
        let comicNumberString = String(comicNumber)
        ComicByNumberRequest(comicNumber: comicNumberString).send { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.currentComic = comic
                    self.updateUI()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func nextComic(_ sender: Any) {
        if let currentComicNumber = currentComicNumber {
            let previousComicToRequest = currentComicNumber + 1
            sendComicRequest(for: previousComicToRequest)
        }
    }
    
    @IBAction func previousComic(_ sender: Any) {
        if let currentComicNumber = currentComicNumber {
            let nextComicToRequest = currentComicNumber - 1
            sendComicRequest(for: nextComicToRequest)
        }
    }
}

