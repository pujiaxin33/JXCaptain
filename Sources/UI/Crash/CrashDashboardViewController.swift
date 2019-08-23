//
//  CrashdashboardViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class CrashDashboardViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Crash日志操作中心"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    //MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell.textLabel?.text = "查看Crash日志"
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "清理Crash日志"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = CrashListViewController(style: .plain)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
            let alert = UIAlertController(title: "提示", message: "确认删除所有Crash日志吗？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                CrashFileManager.deleteAllFiles()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
