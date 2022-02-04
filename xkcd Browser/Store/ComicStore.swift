//
//  ComicStore.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import Foundation

final class ComicStore {
    
    static let shared = ComicStore()
    
    private let store: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private enum Key: String {
        case savedComics
    }
    
    private init(store: UserDefaults = UserDefaults(suiteName: "ComicStore")!) {
        self.store = store
    }
    
    
    
}
