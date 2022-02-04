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
    @IBOutlet weak var saveComicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    let savedComicsManager = SavedComicsManager.shared
    var currentComicIsSaved: Bool {
        guard let currentComicNumber = currentComicNumber else {
            return false
        }
        if savedComicsManager.allSavedComicNumbers.contains(currentComicNumber) {
            return true
        } else {
            return false
        }
    }
    var storedComicDisplayed: StoredComic?
    
    //Latest comic number is used to indicate to the user that there are no newer comics by disabling the next button
    let latestComicNumber = ComicBrowserViewModel.latestComicNumber
    
    //The comic currently displayed
    var currentComicDisplayed: Comic?
    
    var currentComicNumber: Int? {
        if let currentComicDisplayed = currentComicDisplayed {
            return currentComicDisplayed.number
        } else if let storedComicDisplayed = storedComicDisplayed {
            return storedComicDisplayed.comicNumber
        }
        return nil
    }
    var currentComicImage: UIImage?
    
    func updateForFetchedComic(_ comic: Comic) {
        checkIfNext()
        comicImageView.image = nil
        comicTitleLabel.text = comic.title
        comicNumberlabel.text = "#\(comic.number)"
        altTextlabel.text = comic.titleText == "" ? "No alt text" : comic.titleText
        transcriptTextlabel.text = comic.transcript == "" ? "No Transcript" : comic.transcript
        ComicImageRequest(imageURL: comic.img).send() { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.comicImageView.image = image
                    self.currentComicImage = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateForStoredComic(_ comic: StoredComic) {
        comicTitleLabel.text = comic.title
        altTextlabel.text = comic.alt
        transcriptTextlabel.text = comic.transcript
        comicImageView.image = comic.image?.imageFromBase64
    }
    
    func updateUI() {
        toggleSaveButtonImage()
        if let currentComicDisplayed = currentComicDisplayed {
            updateForFetchedComic(currentComicDisplayed)
        } else if let storedComicDisplayed = storedComicDisplayed {
            updateForStoredComic(storedComicDisplayed)
        }
        
        
        print(currentComicIsSaved)
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
    

    func toggleSaveButtonImage() {
        if currentComicIsSaved {
            saveComicButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            saveComicButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
            
    }
    
    func toggleSave() {
        if currentComicIsSaved {
            savedComicsManager.removeSavedComicByComicNumber(comicNumberToRemove: currentComicNumber!)
        } else {
            savedComicsManager.save(currentComicDisplayed!, currentComicImage: currentComicImage)
        }
    }
    
    func sendComicRequest(for comicNumber: Int) {
        let comicNumberString = String(comicNumber)
        ComicByNumberRequest(comicNumber: comicNumberString).send { result in
            switch result {
            case .success(let comic):
                DispatchQueue.main.async {
                    self.currentComicDisplayed = comic
                    self.updateUI()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func nextComicButtonTapped(_ sender: Any) {
        if let currentComicNumber = currentComicNumber {
            let previousComicToRequest = currentComicNumber + 1
            sendComicRequest(for: previousComicToRequest)
        }
    }
    
    @IBAction func previousComicButtonTapped(_ sender: Any) {
        if let currentComicNumber = currentComicNumber {
            let nextComicToRequest = currentComicNumber - 1
            sendComicRequest(for: nextComicToRequest)
        }
    }
    
    @IBAction func saveComicButtonTapped(_ sender: Any) {
        toggleSave()
        toggleSaveButtonImage()        
    }
    
    
}

