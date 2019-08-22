//
//  CrashListViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class CrashListViewController: UITableViewController {
    var dataSource = [SanboxModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Crash日志列表"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dataSource = CrashFileManager.allCrashFiles()
        tableView.reloadData()
    }

    //MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }

}
