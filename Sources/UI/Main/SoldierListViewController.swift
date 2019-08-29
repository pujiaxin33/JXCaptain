//
//  SoldierListViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return viewControllers.first
    }
}

class SoldierListViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var dataSource = [SoldierListSectionModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "工具箱"
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(naviRightItemDidClick))

        var soldiersTeamDict = [String: [Soldier]]()
        var sortedTeams = [String]()
        for soldier in Captain.default.soldiers {
            if soldiersTeamDict[soldier.team] == nil {
                soldiersTeamDict[soldier.team] = [soldier]
                sortedTeams.append(soldier.team)
            }else {
                soldiersTeamDict[soldier.team]?.append(soldier)
            }
        }
        for team in sortedTeams {
            let model = SoldierListSectionModel(teamName: team, soldiers: soldiersTeamDict[team]!)
            dataSource.append(model)
        }

        let itemWidth = CGFloat(floor(UIScreen.main.bounds.size.width/4))
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        layout.headerReferenceSize = CGSize(width: view.bounds.size.width, height: 30)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SoldierListCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SoldierListSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(SoldierListSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "emptyFooter")
        view.addSubview(collectionView)

        NotificationCenter.default.addObserver(self, selector: #selector(soldierNewEventDidChange), name: .JXCaptainSoldierNewEventDidChange, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.frame = view.bounds
    }

    @objc func soldierNewEventDidChange() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    @objc func naviRightItemDidClick() {
        dismiss(animated: true, completion: nil)
    }

    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].soldiers.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SoldierListSectionHeaderView
            header.titleLabel.text = dataSource[indexPath.section].teamName
            return header
        }else if kind == UICollectionView.elementKindSectionFooter {
            if indexPath.section == dataSource.count - 1 {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
                return footer
            }else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "emptyFooter", for: indexPath)
                return footer
            }
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SoldierListCell
        let soldier = dataSource[indexPath.section].soldiers[indexPath.item]
        cell.iconImageView.image = soldier.icon
        cell.nameLabel.text = soldier.name
        cell.customContentView = soldier.contentView
        cell.newEventView.isHidden = !soldier.hasNewEvent
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let soldier = dataSource[indexPath.section].soldiers[indexPath.item]
        soldier.action(naviController: self.navigationController!)
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == dataSource.count - 1 {
            return CGSize(width: view.bounds.size.width, height: 50)
        }else {
            return CGSize.zero
        }
    }
}

/// UI标准
/// Cell布局：高度=60，宽度=屏幕宽度/4
/// nameLabel布局：leading、trailing、bottom都对齐父视图
/// nameLabel属性：textColor = .gray、font = .systemFont(ofSize: 12)、extAlignment = .center
/// iconImageView布局：width = height = 35、top和centerX对齐父视图
class SoldierListCell: UICollectionViewCell {
    let iconImageView: UIImageView
    let nameLabel: UILabel
    let newEventView: UIView
    var customContentView: UIView? {
        didSet {
            iconImageView.isHidden = customContentView != nil
            nameLabel.isHidden = customContentView != nil
            if customContentView != nil {
                contentView.addSubview(customContentView!)
            }
        }
    }

    override init(frame: CGRect) {
        iconImageView = UIImageView()
        nameLabel = UILabel()
        newEventView = UIView()
        super.init(frame: frame)

        iconImageView.contentMode = .scaleToFill
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        iconImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        nameLabel.textColor = .gray
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        newEventView.isHidden = true
        newEventView.backgroundColor = UIColor.red
        newEventView.layer.cornerRadius = 4
        newEventView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newEventView)
        newEventView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        newEventView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 20).isActive = true
        newEventView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        newEventView.heightAnchor.constraint(equalToConstant: 8).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        customContentView?.removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        customContentView?.frame = contentView.bounds
    }
}

class SoldierListSectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel

    override init(frame: CGRect) {
        titleLabel = UILabel()
        super.init(frame: frame)

        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SoldierListSectionFooterView: UICollectionReusableView {
    let closeButton: UIButton

    override init(frame: CGRect) {
        closeButton = UIButton(type: .custom)
        super.init(frame: frame)

        closeButton.setTitle("关闭Captain", for: .normal)
        closeButton.setTitleColor(.red, for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 18)
        closeButton.addTarget(self, action: #selector(closeButtonDidClick), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.layer.cornerRadius = 5
        closeButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func closeButtonDidClick() {
        Captain.default.hide()
    }
}
