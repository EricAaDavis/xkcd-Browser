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
    
    weak var delegate: ComicBrowserViewModelDelegate?
    
    enum Section: Hashable, Comparable {
        case latestComic
        case comics
    }
    
    typealias Item = Comic
    
    var model = Model()
    
    var latestComicNumber: Int? {
        model.latestComic?.number
    }
    
    //Gets the latest comic
    func getLatestComicWithPreviousTwenty() {
        LatestComicRequest().send { result in
            switch result {
            case .success(let comic):
                self.model.latestComic = comic
                let newestComic = comic.number
                let lastComicToFetch = comic.number - 20
                self.getPreviousComicsForNumber(from: newestComic, to: lastComicToFetch)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Gets comics for comic number between a range of comic numbers
    func getPreviousComicsForNumber(from newestComic: Int, to oldetsComic: Int) {
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
    
    func items() -> [Section: [Item]] {
        
        var items: [Section: [Comic]] = [Section.comics: model.comics!]
        
        items[Section.latestComic] = [model.latestComic!]
        
        return items
    }
}

struct Model {
    var latestComic: Comic?
    var comics: [Comic]? = []
}
