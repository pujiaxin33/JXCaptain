//
//  DashboardCell.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    let toggle: UISwitch
    var toggleValueDidChange: ((Bool)->())?

    deinit {
        toggleValueDidChange = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        toggle = UISwitch()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleDidClick), for: .valueChanged)
        contentView.addSubview(toggle)
        toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func toggleDidClick() {
        toggleValueDidChange?(toggle.isOn)
    }
}
