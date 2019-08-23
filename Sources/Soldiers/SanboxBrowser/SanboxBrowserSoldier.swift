//
//  BundleBrowserSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class SanboxBrowserSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView? 
    public init() {
        name = "沙盒浏览"
        team = "常用工具"
        icon = ImageManager.imageWithName("JXCaptain_icon_sanbox")
    }

    public func action() {
    }

    public func moveToDashboard(naviController: UINavigationController) {
        naviController.pushViewController(JXFileBrowserController(path: NSHomeDirectory()), animated: true)
    }
}
