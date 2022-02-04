//
//  File.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import UIKit

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}
