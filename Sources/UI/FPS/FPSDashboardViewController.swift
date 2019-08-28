//
//  FPSDashboardViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class FPSDashboardViewController: UITableViewController {
    let soldier: FPSSoldier

    init(soldier: FPSSoldier) {
        self.soldier = soldier
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FPS"
        tableView.register(DashboardCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashboardCell
        cell.textLabel?.text = "FPS检测开关"
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
