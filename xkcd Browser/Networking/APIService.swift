//
//  APIService.swift
//  xkcd Browser
//
//  Created by Eric Davis on 31/01/2022.
//

import UIKit

struct LatestComicRequest: APIRequest {
    typealias Response = Comic
    
    var path = "/info.0.json"
}

struct ComicByNumberRequest: APIRequest {
    
    typealias Response = Comic
    
    var comicNumber: String
    
    var path: String {
        "/\(comicNumber)/info.0.json"
    }
}
