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
    
    weak var savedComicsDelegate: SavedComicsManagerDelegate?
    
    static let shared = SavedComicsManager()
    
    private let store: ComicStore = ComicStore.shared
    
    var allSavedComicNumbers: [Int] {
        var storedComicsByNumber: [Int] = []
        getSavedComics().forEach { storedComic in
            storedComicsByNumber.append(storedComic.comicNumber)
        }
        return storedComicsByNumber
    }
    
    func save(_ comic: Comic?, currentComicImage: UIImage?) {
        guard let comic = comic,
              let currentComicImage = currentComicImage else { return }
        
        let imageData = currentComicImage.jpegData(compressionQuality: 1)
        
        let comicToStore = StoredComic(
            comicNumber: comic.number,
            title: comic.title,
            alt: comic.titleText,
            transcript: comic.title,
            image: imageData)
        
        store.storedComics.append(comicToStore)
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
    }
}
