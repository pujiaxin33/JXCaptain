//
//  NetworkObserverDashboardViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class NetworkObserverDashboardViewController: UITableViewController {
    let soldier: NetworkObserverSoldier

    init(soldier: NetworkObserverSoldier) {
        self.soldier = soldier
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "流量"
        tableView.register(DashboardCell.self, forCellReuseIdentifier: "swithCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "swithCell", for: indexPath) as! DashboardCell
            cell.textLabel?.text = "流量检测开关"
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
            cell.textLabel?.text = "查看接口请求列表"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "清理接口请求记录"
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let vc = NetworkFlowListViewController(soldier: soldier)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let alert = UIAlertController(title: "提示", message: "确认删除所有接口请求记录吗？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                NetworkObserverSoldier.shared.flowModels.removeAll()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
