//
//  FavoriteComicManager.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import Foundation

protocol FavoriteComicManagerDelegate: AnyObject {
    func favoriteComicsUpdated()
}

final class FavoriteComicManager {
    
    weak var favoriteComicDelegate: FavoriteComicManagerDelegate?
    
    
    static let shared = FavoriteComicManager()
    
    private let store: ComicStore = ComicStore.shared
    
    
    
    
}
