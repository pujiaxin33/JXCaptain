//
//  PerformanceTestViewController.swift
//  Example
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class PerformanceTestViewController: UITableViewController {
    var texts = [NSAttributedString]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "性能测试"
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //卡顿
            Thread.sleep(forTimeInterval: 2)
        }else if indexPath.row == 1 {
            //低fps
            Thread.sleep(forTimeInterval: 0.5)
        }else if indexPath.row == 2 {
            //高cpu
            for number in 1..<10000000 {
                sqrt(pow(Double(number), Double(number)))
            }
        }else if indexPath.row == 3 {
            //高内存
            for index in 0..<100000 {
                texts.append(NSAttributedString(string: "\(index)"))
            }
        }else if indexPath.row == 4 {
            //高流量
            for _ in 0..<10 {
                let url = URL(string: "https://www.taobao.com/")!
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if response != nil {
                        print(response!)
                    }
                }
                task.resume()
            }
        }
    }
}
