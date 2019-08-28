//
//  PerformanceTestViewController.swift
//  Example
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class PerformanceTestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "性能测试"
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Thread.sleep(forTimeInterval: 2)
        }else if indexPath.row == 1 {

        }
    }

}
