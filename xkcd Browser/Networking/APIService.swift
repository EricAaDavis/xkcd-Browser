//
//  APIService.swift
//  xkcd Browser
//
//  Created by Eric Davis on 31/01/2022.
//

import UIKit

struct LatestComicRequest: APIRequest {
    typealias Response = Comic
    
    var path: String = "/info.0.json"
}

struct ComicByNumberRequest: APIRequest {
    typealias Response = Comic
    
    var comicNumber: String
    
    var path: String {
        "/\(comicNumber)/info.0.json"
    }
}

struct ComicImageRequest: APIRequest {
    typealias Response = UIImage
    
    var imageURL: URL?    
}



