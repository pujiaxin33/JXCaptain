//
//  BaseNavigationViewController.swift
//  Example
//
//  Created by jiaxin on 2019/9/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
