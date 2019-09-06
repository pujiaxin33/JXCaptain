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
        }else if indexPath.row == 2 {
            let url = URL(string: "https://cn.bing.com/th?id=OIP.MehRXMQpJaV17DMm_MySxgHaFR&pid=Api&rs=1")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if response != nil {
                    print(response!)
                }
            }
            task.resume()
        }else if indexPath.row == 3 {
            let url = URL(string: "http://pic38.nipic.com/20140217/14150008_155520585000_2.gif")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if response != nil {
                    print(response!)
                }
            }
            task.resume()
        }else if indexPath.row == 4 {
            let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if response != nil {
                    print(response!)
                }
            }
            task.resume()
        }else if indexPath.row == 5 {
            let url = URL(string: "https://gitee.com/xiansanyee/codes/saix3etdh0bywm4pr9gzl38/raw?blob_name=News.mp3")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if response != nil {
                    print(response!)
                }
            }
            task.resume()
        }else if indexPath.row == 6 {
            let vc = UIWebViewViewController()
            navigationController?.pushViewController(vc, animated: true)
        }

        if indexPath.row != 6 {
            let alert = UIAlertController(title: nil, message: "发送成功", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
