//
//  NetworkFlowDetailCellModel.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

enum NetworkFlowDetailCellType {
    case normal
    case requestBody
    case responseBody
}

struct NetworkFlowDetailCellModel {
    let type: NetworkFlowDetailCellType
    let text: NSAttributedString

    init(type: NetworkFlowDetailCellType = .normal, text: NSAttributedString) {
        self.type = type
        self.text = text
    }
}
