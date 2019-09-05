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

        title = "请求列表"

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "搜索URL"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        tableView.register(NetworkFlowListCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = searchController.searchBar

        NotificationCenter.default.addObserver(self, selector: #selector(newFlowDidReceive(noti:)), name: NSNotification.Name.JXCaptainNetworkObserverSoldierNewFlowDidReceive, object: nil)
    }

    @objc func newFlowDidReceive(noti: Notification) {
        guard let flowModel = noti.object as? NetworkFlowModel else {
            return
        }
        dataSource.insert(flowModel, at: 0)
        if searchController.isActive, let searchText = searchController.searchBar.text {
            if flowModel.request.url?.absoluteString.range(of: searchText, options: .caseInsensitive) != nil {
                filteredDataSource.insert(flowModel, at: 0)
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            }
        }else {
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredDataSource.count
        }else {
            return dataSource.count
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NetworkFlowListCell
        let flowModel = dataSource[indexPath.row]
        if flowModel.errorString != nil {
            cell.urlLabel.textColor = .red
            cell.infoLabel.text = "\(flowModel.method) · \(flowModel.downFlow) · \(flowModel.durationString) · \(flowModel.startDateString)"
        }else {
            cell.urlLabel.textColor = .black
            let infoString = "\(flowModel.method) · \(flowModel.statusCode ?? -1) · \(flowModel.downFlow) · \(flowModel.durationString) · \(flowModel.startDateString)"
            if flowModel.isStatusCodeError {
                let statusCodeString = "\(flowModel.statusCode ?? -1)"
                let infoText = NSMutableAttributedString(string: infoString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
                infoText.addAttribute(.foregroundColor, value: UIColor.red, range: NSString(string: infoString).range(of: statusCodeString))
                cell.infoLabel.attributedText = infoText
            }else {
                cell.infoLabel.text = infoString
            }
        }
        cell.urlLabel.text = flowModel.urlString
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchController.isActive = false
        let vc = NetworkFlowDetailViewController(flowModel: dataSource[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
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
        urlLabel.font = .systemFont(ofSize: 13)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.numberOfLines = 2
        contentView.addSubview(urlLabel)
        urlLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true

        infoLabel.textColor = .gray
        infoLabel.font = .systemFont(ofSize: 10)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 1
        contentView.addSubview(infoLabel)
        infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        infoLabel.attributedText = nil
        infoLabel.text = nil
    }
}
