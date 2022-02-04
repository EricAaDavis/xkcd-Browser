//
//  ComicStore.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import Foundation

typealias StoredComics = [StoredComic]

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
    
    var storedComics: StoredComics {
        get { retrieve(for: .savedComics) ?? [] }
        set { store(newValue, for: .savedComics) }
    }
    
    //MARK: - Store Helper
    
    
    private func store<T: Encodable>(_ object: T?, for key: Key) {
        let key = wrap(key)
        guard let object = object else {
            store.removeObject(forKey: key)
            return
        }
        guard let encodedObject = try? encoder.encode(object) else {
            print("Can't encode object with type: '\(object.self)'")
            return
        }
        store.set(encodedObject, forKey: key)
    }
    
    private func retrieve<T: Decodable>(for key: Key) -> T? {
        guard let savedObject = store.data(forKey: wrap(key)),
              let object = try? decoder.decode(T.self, from: savedObject) else {
                  return nil
              }
        return object
    }
    
    private func wrap(_ key: Key) -> String {
        let rawKey = key.rawValue
#if DEBUG
        return rawKey + "_debug"
#else
        return rawKey
#endif
    }
}
