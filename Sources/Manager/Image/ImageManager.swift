//
//  ImageManager.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class ImageManager {
    static func imageWithName(_ name: String) -> UIImage? {
        let frameworkBundle = Bundle(for: Captain.self)
        let resourceBundleURL = frameworkBundle.url(forResource: "Resource", withExtension: "bundle")
        let resourceBundle = Bundle(url: resourceBundleURL!)
        return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
    }
}


