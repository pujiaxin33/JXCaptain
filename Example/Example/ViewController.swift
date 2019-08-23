//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/8/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXCaptain

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "呼叫队长", style: .plain, target: self, action: #selector(naviRightItemDidClick))

        Captain.default.enqueueSoldier(ServerEnvironmentSoldier())
        Captain.default.action()
    }

    @objc func naviRightItemDidClick() {
        Captain.default.show()
    }
}

