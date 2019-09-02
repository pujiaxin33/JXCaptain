//
//  FileListViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class FileListViewController: UITableViewController {
    let dataSource: [SanboxModel]

    init(dataSource: [SanboxModel]) {
        self.dataSource = dataSource
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        if dataSource.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.font = .systemFont(ofSize: 25)
            emptyLabel.text = "暂无日志文件"
            emptyLabel.textAlignment = .center
            tableView.backgroundView = emptyLabel
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
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
