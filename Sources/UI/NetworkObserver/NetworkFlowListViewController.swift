//
//  NetworkFlowListViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class NetworkFlowListViewController: UITableViewController {
    let soldier: NetworkObserverSoldier
    var dataSource: [NetworkFlowModel]
    var searchController: UISearchController!
    var filteredDataSource = [NetworkFlowModel]()

    init(soldier: NetworkObserverSoldier) {
        self.soldier = soldier
        dataSource = soldier.flowModels
        super.init(style: .plain)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "搜索URL"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        tableView.register(NetworkFlowListCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = searchController.searchBar
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredDataSource.count
        }else {
            return dataSource.count
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NetworkFlowListCell
        let flowModel = dataSource[indexPath.row]
        cell.urlLabel.text = flowModel.urlString
        cell.infoLabel.text = "\(flowModel.method ?? "") · \(flowModel.statusCode ?? -1) · \(flowModel.downFlow ?? "") · \(flowModel.durationString ?? "")"
        return cell
    }

}

extension NetworkFlowListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredDataSource.removeAll()
        if searchController.searchBar.text?.isEmpty == false {
            for flowModel in dataSource {
                if flowModel.urlString?.range(of: searchController.searchBar.text!, options: .caseInsensitive) != nil {
                    filteredDataSource.append(flowModel)
                }
            }
        }else {
            filteredDataSource = dataSource
        }
        tableView.reloadData()
    }
}


class NetworkFlowListCell: UITableViewCell {
    let urlLabel: UILabel
    let infoLabel: UILabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        urlLabel = UILabel()
        infoLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        urlLabel.textColor = .black
        urlLabel.font = .systemFont(ofSize: 12)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.numberOfLines = 2
        contentView.addSubview(urlLabel)
        urlLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true

        infoLabel.textColor = .lightGray
        infoLabel.font = .systemFont(ofSize: 9)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.numberOfLines = 1
        contentView.addSubview(infoLabel)
        infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
