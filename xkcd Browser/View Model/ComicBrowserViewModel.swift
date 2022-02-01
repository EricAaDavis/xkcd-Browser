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
    
    var model = Model()
    
    func getLatestComic() {
        LatestComicRequest().send { result in
            switch result {
            case .success(let comic):
                self.model.latestComic = comic
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.delegate?.itemsChanged()
                //Call delegate method here
            }
        }
    }
    
    //Gets comics for comic number between a range of comic numbers
    func getPreviousComicsForNumber(from newestComic: Int, to oldetsComic: Int) {
        let group = DispatchGroup()
        
        for comicNumber in newestComic...oldetsComic {
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
    
    
    
    func items() -> [Comic]? {
        return model.comics
    }
}




struct Model {
    var latestComic: Comic?
    var comics: [Comic]? = []
}
