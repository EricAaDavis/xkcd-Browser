//
//  String+.swift
//  xkcd Browser
//
//  Created by Eric Davis on 04/02/2022.
//

import Foundation
import UIKit

extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
