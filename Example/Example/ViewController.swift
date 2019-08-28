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

        //在prepare之前添加自定义Soldier
        Captain.default.enqueueSoldier(ServerEnvironmentSoldier())
        //在prepare之前赋值自定义Soldier闭包
        Captain.default.configSoldierClosure = { (soldier) in
            /*
            if let websiteEntry = soldier as? WebsiteEntrySoldier {
                //设置H5任意门默认网址
                websiteEntry.defaultWebsite = "https://www.baidu.com"
                //设置H5任意门自定义落地页面，比如项目有自定义WKWebView、有JS交互逻辑等
                websiteEntry.webDetailControllerClosure = { (website) in
                    return UIViewController()
                }
            }
            */
            /*
            if let anr = soldier as? ANRSoldier {
                //设置卡顿时间阈值，单位秒
                anr.threshold = 2
            }
            */
            /*
            if let crash = soldier as? CrashSoldier {
                //自定义处理crash信息，可以存储到本地，下次打开app再传送到服务器记录
                crash.exceptionReceiveClosure = { (signal, exception, info) in
                    if signal != nil {
                        print("signal crash info:\(info ?? "")")
                    }else if exception != nil {
                        print("exception crash info:\(info ?? "")")
                    }
                }
            }
            */
        }

        //最后再调用prepare
        Captain.default.prepare()
    }

    @objc func naviRightItemDidClick() {
        Captain.default.show()
    }
}

