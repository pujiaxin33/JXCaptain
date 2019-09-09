//
//  UserDefaultsKeyValuesListViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/9.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class UserDefaultsKeyValuesListViewController: BaseTableViewController {
    let defaults: UserDefaults
    var dataSource = [UserDefaultsKeyValueModel]()
    var filteredDataSource = [UserDefaultsKeyValueModel]()
    var searchController: UISearchController!

    init(defaults: UserDefaults) {
        self.defaults = defaults

        var tempDataSource = [UserDefaultsKeyValueModel]()
        defaults.dictionaryRepresentation().forEach { (keyValue) in
            let model = UserDefaultsKeyValueModel(key: keyValue.key, value: keyValue.value, userDefaults: defaults)
            tempDataSource.append(model)
        }
        tempDataSource.sort { (model1, model2) -> Bool in
            return model1.key < model2.key
        }
        dataSource = tempDataSource
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Key Value List"

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "key filter"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(UserDefaultsKeyValuesListCell.self, forCellReuseIdentifier: "cell")

        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChangeNotification(_:)), name: UserDefaults.didChangeNotification, object: nil)
    }

    func refreshDataSource() {
        var tempDataSource = [UserDefaultsKeyValueModel]()
        defaults.dictionaryRepresentation().forEach { (keyValue) in
            let model = UserDefaultsKeyValueModel(key: keyValue.key, value: keyValue.value, userDefaults: defaults)
            tempDataSource.append(model)
        }
        tempDataSource.sort { (model1, model2) -> Bool in
            return model1.key < model2.key
        }
        dataSource = tempDataSource
    }

    @objc func userDefaultsDidChangeNotification(_ noti: Notification) {
        DispatchQueue.main.async {
            self.refreshDataSource()
            self.tableView.reloadData()
        }
    }

    //MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredDataSource.count
        }
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var model: UserDefaultsKeyValueModel!
        if searchController.isActive {
            model = filteredDataSource[indexPath.row]
        }else {
            model = dataSource[indexPath.row]
        }
        cell.textLabel?.text = model.key
        cell.detailTextLabel?.text = model.valueDescription()
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model: UserDefaultsKeyValueModel!
        if searchController.isActive {
            model = filteredDataSource[indexPath.row]
        }else {
            model = dataSource[indexPath.row]
        }
        searchController.isActive = false
        let vc = UserDefaultsKeyValueDetailViewController(defaults: defaults, keyValueModel: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserDefaultsKeyValuesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.isEmpty == false {
            filteredDataSource.removeAll()
            for model in dataSource {
                if model.key.range(of: searchController.searchBar.text!, options: .caseInsensitive) != nil {
                    filteredDataSource.append(model)
                }
            }
        }else {
            filteredDataSource = dataSource
        }
        tableView.reloadData()
    }
}

class UserDefaultsKeyValuesListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
