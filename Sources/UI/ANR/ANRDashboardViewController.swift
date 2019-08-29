//
//  ANRDashboardViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class ANRDashboardViewController: UITableViewController {
    let soldier: ANRSoldier

    init(soldier: ANRSoldier) {
        self.soldier = soldier
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "卡顿操作中心"
        tableView.register(DashboardCell.self, forCellReuseIdentifier: "swithCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        soldier.hasNewEvent = false
        NotificationCenter.default.post(name: .JXCaptainSoldierNewEventDidChange, object: soldier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "swithCell", for: indexPath) as! DashboardCell
            cell.textLabel?.text = "卡顿检测开关"
            cell.toggle.isOn = soldier.isActive
            cell.toggleValueDidChange = {[weak self] (isOn) in
                if isOn {
                    self?.soldier.start()
                }else {
                    self?.soldier.end()
                }
            }
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "查看卡顿日志"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "清理卡顿日志"
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = ANRListViewController(dataSource: ANRFileManager.allFiles())
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let alert = UIAlertController(title: "提示", message: "确认删除所有卡顿日志吗？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                ANRFileManager.deleteAllFiles()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
