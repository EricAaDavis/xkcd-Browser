//
//  Constants.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import Foundation

//C is for constants
struct C {
    static let shared = C()
    
    let comicCellReuseIdentifier = "ComicCell"
    let latestComicSectionHeaderKind = "LatestComicKind"
    
    //MARK: - Segue Identifiers
    let detailedScreenSegueIdentiferFromBrowse = "ShowDetailedScreenFromBrowse"
    let detailedScreenSegueIdentifierFromSaved = "ShowDetailedScreenFromSaved"
}
