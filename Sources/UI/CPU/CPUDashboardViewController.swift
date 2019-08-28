//
//  CPUDashboardViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class CPUDashboardViewController: UITableViewController {
    let soldier: CPUSoldier

    init(soldier: CPUSoldier) {
        self.soldier = soldier
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CPU"
        tableView.register(DashboardCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashboardCell
        cell.textLabel?.text = "CPU检测开关"
        cell.toggle.isOn = soldier.isActive
        cell.toggleValueDidChange = {[weak self] (isOn) in
            if isOn {
                self?.soldier.start()
            }else {
                self?.soldier.end()
            }
        }
        return cell
    }

}
