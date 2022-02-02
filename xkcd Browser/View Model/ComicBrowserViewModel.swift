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
    
    typealias Item = Comic
    
    var model = Model()
    var featuredComic: Comic? {
        didSet {
            delegate?.itemsChanged()
        }
    }
    
    //This variable is the number of items to fetch for getPreviousComicsForNumber
    let numberOfItemsToFetch = 21
    var newestComicNumber = 0
    var lastComicNumber: Int {
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
                self.model.latestComic = comic
                self.newestComicNumber = comic.number - 1
                self.getPreviousComicsForNumber(from: self.lastComicNumber, to: self.newestComicNumber)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Gets comics for comic number within a range of commic numbers
    func getPreviousComicsForNumber(from oldetsComic: Int, to newestComic: Int) {
        let group = DispatchGroup()
        for comicNumber in oldetsComic...newestComic {
            let comicNumberString = String(comicNumber)
            group.enter()
            ComicByNumberRequest(comicNumber: comicNumberString).send { result in
                switch result {
                case .success(let comic):
                    self.model.comics?.append(comic)
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
    
    func getSpecificComicByNumber(numberString: String) {
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

struct Model {
    var latestComic: Comic?
    var comics: [Comic]? = []
}
