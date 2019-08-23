//
//  WebsiteSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class WebsiteEntrySoldier: Soldier {
    public static var defaultWebsite: String?
    public static var webDetailControllerClosure: ((String)->(UIViewController))?
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?

    deinit {
        WebsiteEntrySoldier.webDetailControllerClosure = nil
    }

    public init() {
        name = "H5任意门"
        team = "常用工具"
        icon = ImageManager.imageWithName("icon_h5")
    }

    public func action() {
    }

    public func moveToDashboard(naviController: UINavigationController) {
        naviController.pushViewController(WebsiteEntryViewController(), animated: true)
    }
}
