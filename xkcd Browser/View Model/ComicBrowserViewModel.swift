//
//  ComicBrowserViewModel.swift
//  xkcd Browser
//
//  Created by Eric Davis on 01/02/2022.
//

import UIKit

protocol ComicBrowserViewModelDelegate: AnyObject {
    func itemsChanged()
}

final class ComicBrowserViewModel {
    
    enum Section {
        case featuredComic
        case comics
    }
    
    weak var delegate: ComicBrowserViewModelDelegate?
    
    var model = Model()
    
    var featuredComic: Comic? {
        didSet {
            delegate?.itemsChanged()
        }
    }
    
    static var latestComicNumber: Int?
    
    private var newestComicNumber = 0
    //numberOfItemsToFetch is the number of items to fetch for getPreviousComicsForNumber
    private let numberOfItemsToFetch = 21
    private var lastComicNumber: Int {
        newestComicNumber - numberOfItemsToFetch
    }
    
    //Get the next comics in queue.
    func getNextComics() {
        newestComicNumber -= (numberOfItemsToFetch + 1)
        getPreviousComicsForNumber(from: lastComicNumber, to: newestComicNumber)
    }
    
    //MARK: Networking methods for the browse view model.
    //Gets the latest comic
    func getLatestComicWithNumberOfItemsToFetch() {
        model.comics = []
        LatestComicRequest().send { result in
            switch result {
            case .success(let comic):
                ComicBrowserViewModel.latestComicNumber = comic.number
                self.model.latestComic = comic
                self.newestComicNumber = comic.number - 1
                self.getPreviousComicsForNumber(from: self.lastComicNumber, to: self.newestComicNumber)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Gets comics for comic number within a range of comic numbers
    func getPreviousComicsForNumber(from oldestComic: Int, to newestComic: Int) {
        let group = DispatchGroup()
        for comicNumber in oldestComic...newestComic {
            let comicNumberString = String(comicNumber)
            group.enter()
            ComicByNumberRequest(comicNumber: comicNumberString).send { result in
                switch result {
                case .success(let comic):
                    self.model.comics.append(comic)
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        
        //The group notifies whenever all comics have been fetched
        group.notify(queue: .main) {
            self.delegate?.itemsChanged()
        }
    }
    
    //Gets a specific comic by its comic number
    func getComicByNumber(numberString: String) {
        ComicByNumberRequest(comicNumber: numberString).send { result in
            switch result {
            case .success(let comic):
                self.featuredComic = comic
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.delegate?.itemsChanged()
            }
        }
    }
}

//Creates a nice seperation of the model from the view model
struct Model {
    var latestComic: Comic?
    var comics: [Comic] = []
}
