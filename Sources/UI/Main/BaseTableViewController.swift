//
//  BaseTableViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/9.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
