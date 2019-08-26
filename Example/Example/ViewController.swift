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
        tableView.tableFooterView = UIView()

        Captain.default.enqueueSoldier(ServerEnvironmentSoldier())
        //enqueueSoldier完之后再调用prepare
        Captain.default.prepare()
        //设置H5任意门默认网址
//        WebsiteEntrySoldier.defaultWebsite = "https://www.baidu.com"
        //设置H5任意门自定义落地页面，比如项目有自定义WKWebView、有JS交互逻辑等
//        WebsiteEntrySoldier.webDetailControllerClosure = { (website) in
//            return UIViewController()
//        }
    }

    @objc func naviRightItemDidClick() {
        Captain.default.show()
    }
}

