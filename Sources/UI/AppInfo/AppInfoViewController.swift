//
//  AppInfoViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class AppInfoViewController: UITableViewController {
    var dataSource = [AppInfoSectionModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "APP信息"

        tableView.register(AppInfoCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        let phoneCellModels = [AppInfoCellModel(title: "手机型号", info: AppInfoManager.iphoneName()),
                               AppInfoCellModel(title: "系统版本", info: AppInfoManager.iOSVersion())]
        let phoneInfo = AppInfoSectionModel(title: "手机信息", cellModels: phoneCellModels)
        let appCellModels = [AppInfoCellModel(title: "BundleID", info: AppInfoManager.bundleID()),
                             AppInfoCellModel(title: "Version", info: AppInfoManager.bundleVersion()),
                             AppInfoCellModel(title: "VersionCode", info: AppInfoManager.bundleCode())]
        let appInfo = AppInfoSectionModel(title: "APP信息", cellModels: appCellModels)
        let authorityCellModels = [AppInfoCellModel(title: "地理位置权限", info: AppInfoManager.locationAuthority()),
                                   AppInfoCellModel(title: "网络权限", info: AppInfoManager.networkAuthority()),
                                   AppInfoCellModel(title: "通知权限", info: AppInfoManager.notificationAuthority()),
                                   AppInfoCellModel(title: "相机权限", info: AppInfoManager.cameraAuthority()),
                                   AppInfoCellModel(title: "麦克风权限", info: AppInfoManager.audioAuthority()),
                                   AppInfoCellModel(title: "相册权限", info: AppInfoManager.cameraAuthority()),
                                   AppInfoCellModel(title: "通讯录权限", info: AppInfoManager.contactsAuthority()),
                                   AppInfoCellModel(title: "日历权限", info: AppInfoManager.calendarAuthority()),
                                   AppInfoCellModel(title: "提醒事项权限", info: AppInfoManager.reminderAuthority())]
        let authorityInfo = AppInfoSectionModel(title: "权限信息", cellModels: authorityCellModels)
        dataSource.append(contentsOf: [phoneInfo, appInfo, authorityInfo])
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].cellModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AppInfoCell
        let cellModel = dataSource[indexPath.section].cellModels[indexPath.row]
        cell.titleLabel.text = cellModel.title
        cell.infoLabel.text = cellModel.info
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
}

struct AppInfoSectionModel {
    let title: String
    let cellModels: [AppInfoCellModel]
}

struct AppInfoCellModel {
    let title: String
    let info: String
}

class AppInfoCell: UITableViewCell {
    let titleLabel: UILabel
    let infoLabel: UILabel

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel()
        infoLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        infoLabel.font = .systemFont(ofSize: 15)
        infoLabel.textColor = .gray
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoLabel)
        infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
