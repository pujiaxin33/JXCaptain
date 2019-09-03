//
//  BaseViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

class BaseNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return topController()
    }

    override var childForStatusBarHidden: UIViewController? {
        return topController()
    }
}

extension UIViewController {
    func topController() -> UIViewController? {
        if let navi = self as? UINavigationController {
            return navi.topViewController?.topController()
        }else if let tabbar = self as? UITabBarController {
            return tabbar.selectedViewController?.topController()
        }else if presentedViewController != nil {
            return presentedViewController?.topController()
        }else {
            return self
        }
    }
}
