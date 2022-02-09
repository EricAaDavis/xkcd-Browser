//
//  File.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import UIKit

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 0.5)?.base64EncodedString()
    }
}
