//
//  SanboxModel.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public struct SanboxModel {
    public let fileURL: URL
    public let name: String
    public init(fileURL: URL, name: String) {
        self.fileURL = fileURL
        self.name = name
    }
}
