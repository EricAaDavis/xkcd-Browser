//
//  SavedComicsManager.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import Foundation
import UIKit

protocol SavedComicsManagerDelegate: AnyObject {
    func savedComicsUpdated()
}

final class SavedComicsManager {
    
    weak var delegate: SavedComicsManagerDelegate?
    
    static let shared = SavedComicsManager()
    
    private let store: ComicStore = ComicStore.shared
    
    var allSavedComicNumbers: [Int] {
        var storedComicsByNumber: [Int] = []
        getSavedComics().forEach { storedComic in
            storedComicsByNumber.append(storedComic.comicNumber)
        }
        return storedComicsByNumber
    }
    
    //saves a Comic as a StoredComic
    func save(_ comic: Comic?, currentComicImage: UIImage?) {
        guard let comic = comic,
              let currentComicImage = currentComicImage else { return }
        
        let imageData = currentComicImage.base64
        
        let comicToStore = StoredComic(
            comicNumber: comic.number,
            title: comic.title,
            alt: comic.alt,
            transcript: comic.transcript,
            image: imageData)
        
        store.storedComics.append(comicToStore)
        delegate?.savedComicsUpdated()
    }
    
    //Saves a stored comic if the user unsaves and saves a comic in the detailed view
    func save(_ comic: StoredComic) {
        store.storedComics.append(comic)
        delegate?.savedComicsUpdated()
    }
    
    func getSavedComics() -> [StoredComic] {
        store.storedComics.sorted { lhs, rhs in
            lhs.comicNumber > rhs.comicNumber
        }
    }
    
    func removeSavedComicByComicNumber(comicNumberToRemove: Int) {
        var storedComics = store.storedComics
        storedComics.removeAll { storedComic in
            storedComic.comicNumber == comicNumberToRemove
        }
        store.storedComics = storedComics
        delegate?.savedComicsUpdated()
    }
}
