//
//  JXTableListViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXTableListViewController: UITableViewController {
    let filePath: String
    let tableNames: [String]

    init(filePath: String) {
        self.filePath = filePath
        let connector = JXDatabaseConnector(path: filePath)
        tableNames = connector.allTables()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(didNaviShareItemClick))
    }

    class func supportsExtension(_ extension: String) -> Bool {
        let extensions = ["db", "sqlite", "sqlite3"]
        return extensions.contains(`extension`)
    }

    @objc func didNaviShareItemClick() {
        let activityController = UIActivityViewController(activityItems: [URL(fileURLWithPath: filePath)], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }

    //MARK: - UITableViewDataSource & UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableNames[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = JXTableContentViewController(filePath: filePath, tableName: tableNames[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
