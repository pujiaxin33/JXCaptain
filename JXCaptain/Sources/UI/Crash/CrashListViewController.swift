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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let sheet = UIAlertController(title: nil, message: "请选择操作方式", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "本地预览", style: .default, handler: { (action) in
            let previewVC = JXFilePreviewViewController(filePath: model.fileURL.path)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "分享", style: .default, handler: { (action) in
            let activityController = UIActivityViewController(activityItems: [model.fileURL], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
}
