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
    var titleText: String
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
        case titleText = "alt"
        case transcript
        case img

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.number = try container.decode(Int.self, forKey: .number)
        self.year = try container.decode(String.self, forKey: .year)
        self.month = try container.decode(String.self, forKey: .month)
        self.day = try container.decode(String.self, forKey: .day)
        self.link = try container.decode(String.self, forKey: .link)
        self.news = try container.decode(String.self, forKey: .news)
        self.safeTitle = try container.decode(String.self, forKey: .safeTitle)
        self.title = try container.decode(String.self, forKey: .title)
        self.titleText = try container.decode(String.self, forKey: .titleText)
        self.transcript = try container.decode(String.self, forKey: .transcript)
        self.img = try container.decode(URL.self, forKey: .img)
    }
    
}

extension Comic: Codable {  }

//Hashable needs to be implemented for diffing in the collection view
extension Comic: Hashable {  }

