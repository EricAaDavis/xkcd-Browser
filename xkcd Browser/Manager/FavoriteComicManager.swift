//
//  FavoriteComicManager.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import Foundation

protocol SavedComicsManager: AnyObject {
    func savedComicsUpdated()
}

final class FavoriteComicManager {
    
    weak var favoriteComicDelegate: SavedComicsManager?
    
    static let shared = FavoriteComicManager()
    
    private let store: ComicStore = ComicStore.shared
    
    
    func save(_ comic: StoredComic) {
        
    }
    
    func getSavedComics() -> [StoredComic] {
        
    }
    
    
    
}
