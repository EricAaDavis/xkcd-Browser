//
//  ComicBrowserViewModelUtils.swift
//  xkcd Browser
//
//  Created by Eric Davis on 01/02/2022.
//

import Foundation

struct ComicBrowserUtils {
    
    //Returns the comic number for the last comic to fetch based on how many comics desired to fetch
    func lastComicToFetch(latestComicNumber: Int, numberOfItemsToFetch: Int) -> Int {
        //if latestComicNumber is less then numberOfItemsTofetch, then it means we are near the end and can fetch the rest of the comics
        if latestComicNumber <= numberOfItemsToFetch {
            return 1
        } else {
            return latestComicNumber - numberOfItemsToFetch
        }
    }
}
