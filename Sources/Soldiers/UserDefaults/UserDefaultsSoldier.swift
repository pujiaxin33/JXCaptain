//
//  UserDefaultsSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/9.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class UserDefaultsSoldier: Soldier {
    public static let shared = UserDefaultsSoldier()
    public var name: String
    public var team: String
    public var icon: UIImage?

    public init() {
        name = "UserDefaults"
        team = "常用工具"
        icon = ImageManager.imageWithName("JXCaptain_icon_app_user_defaults")
    }

    public func prepare() { }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(UserDefaultsKeyValuesListViewController(defaults: UserDefaults.standard), animated: true)
    }
}
