//
//  StoredComic.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//


import UIKit

struct StoredComic {
    let comicNumber: Int
    let title: String
    let alt: String
    let transcript: String
    let image: Data
}

extension StoredComic: Codable {  }
