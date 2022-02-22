//
//  Comic.swift
//  xkcd Browser
//
//  Created by Eric Davis on 31/01/2022.
//

import Foundation

struct Comic {
    var number: Int
    var year: String
    var month: String
    var day: String
    var link: String
    var news: String
    var safeTitle: String
    var title: String
    var alt: String
    var transcript: String
    var img: URL
    
    enum CodingKeys: String, CodingKey {
        case number = "num"
        case year
        case month
        case day
        case link
        case news
        case safeTitle = "safe_title"
        case title
        case alt
        case transcript
        case img
    }
}

extension Comic: Codable {  }

//Hashable needs to be adopted for diffing in the collection view
extension Comic: Hashable {  }

