//
//  NetworkTestViewController.swift
//  Example
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class NetworkTestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "网络测试"
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let url = URL(string: "https://www.taobao.com/")!
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue()) { (response, data, error) in
                if response != nil {
                    print(response!)
                }
            }
        }else if indexPath.row == 1 {
            let url = URL(string: "https://www.jd.com/")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if response != nil {
                    print(response!)
                }
            }
            task.resume()
        }
        let alert = UIAlertController(title: nil, message: "发送成功", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
