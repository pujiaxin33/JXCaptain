//
//  ServerEnvironmentSoldier.swift
//  Example
//
//  Created by jiaxin on 2019/8/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import JXCaptain

class ServerEnvironmentSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    public var hasNewEvent: Bool = false

    public init() {
        name = "线上环境"
        team = "业务工具"
        let myContentView = ServerEnvironmentContentView()
        myContentView.toggle.isOn = true
        myContentView.nameLabel.text = name
        contentView = myContentView
    }

    public func prepare() {
    }

    public func action(naviController: UINavigationController) {
    }
}

class ServerEnvironmentContentView: UIView {
    let toggle: UISwitch
    let nameLabel: UILabel

    override init(frame: CGRect) {
        toggle = UISwitch()
        nameLabel = UILabel()
        super.init(frame: frame)

        toggle.isOn = UserDefaults.standard.bool(forKey: "kServerEnvironment")
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleDidClick), for: .valueChanged)
        addSubview(toggle)
        toggle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        toggle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        nameLabel.textColor = .gray
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func toggleDidClick() {
        UserDefaults.standard.set(toggle.isOn, forKey: "kServerEnvironment")
    }
}
