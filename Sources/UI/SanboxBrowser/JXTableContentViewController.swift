//
//  JXTableContentViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXTableContentViewController: UIViewController {
    let filePath: String
    let tableName: String
    let excelView: ExcelView
    let connector: JXDatabaseConnector
    let allColumns: [String]
    let allDatabaseData: [[String:Any]]
    let allRowStrings: [[String]]

    init(filePath: String, tableName: String) {
        self.filePath = filePath
        self.tableName = tableName
        connector = JXDatabaseConnector(path: filePath)
        allColumns = connector.allColumns(with: tableName)
        allDatabaseData = connector.allData(with: tableName)
        var tempAllRowStrings = [[String]]()
        for row in 0..<allDatabaseData.count {
            let rowData = allDatabaseData[row]
            var rowStrings = [String]()
            for column in 0..<allColumns.count {
                let columnName = allColumns[column]
                let value = rowData[columnName]
                rowStrings.append("\(value ?? "")")
            }
            tempAllRowStrings.append(rowStrings)
        }
        allRowStrings = tempAllRowStrings
        excelView = ExcelView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        excelView.delegate = self
        excelView.dataSource = self
        view.addSubview(excelView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(didNaviShareItemClick))
    }

    @objc func didNaviShareItemClick() {
        let activityController = UIActivityViewController(activityItems: [URL(fileURLWithPath: filePath)], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        excelView.frame = view.bounds
    }
}

extension JXTableContentViewController: ExcelViewDelegate {
    func excelView(_ excelView: ExcelView, didTapGridWith content: String) {
        let vc = JXTextPreviewViewController(text: content)
        navigationController?.pushViewController(vc, animated: true)
    }

    func excelView(_ excelView: ExcelView, didTapColumnNameWith name: String) {
    }
}

extension JXTableContentViewController: ExcelViewDataSource {
    func numberOfRows(in excelView: ExcelView) -> Int {
        return allDatabaseData.count
    }

    func numberOfColumns(in excelView: ExcelView) -> Int {
        return allColumns.count
    }

    func excelView(_ excelView: ExcelView, rowNameAt row: Int) -> String {
        return "\(row)"
    }

    func excelView(_ excelView: ExcelView, columnNameAt column: Int) -> String {
        return allColumns[column]
    }

    func excelView(_ excelView: ExcelView, rowDatasAt row: Int) -> [String] {
        return allRowStrings[row]
    }

    func excelView(_ excelView: ExcelView, rowHeightAt row: Int) -> CGFloat {
        return 40
    }

    func excelView(_ excelView: ExcelView, columnWidthAt column: Int) -> CGFloat {
        return 120
    }

    func widthOfLeftHeader(in excelView: ExcelView) -> CGFloat {
        return 40
    }

    func heightOfTopHeader(in excelView: ExcelView) -> CGFloat {
        return 40
    }
}
