//
//  MonitorListView.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class MonitorListWindow: UIWindow {
    static let `shared` = MonitorListWindow()
    private var monitorViews: [UIView] = [UIView]()
    private let contentHeight: CGFloat = 20
    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.windowLevel = .alert
        if rootViewController == nil {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.clear
            let contentBGView = UIView()
            contentBGView.backgroundColor = UIColor.black
            var y: CGFloat = 0
            if #available(iOS 11.0, *) {
                if safeAreaInsets.top > 20 {
                    y = 30
                }
            }
            contentBGView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: y + contentHeight)
            vc.view.addSubview(contentBGView)
            containerView.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.size.width, height: contentHeight)
            vc.view.addSubview(containerView)
            rootViewController = vc
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .clear
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }

    func show() {
        isHidden = false
    }

    func hide() {
        isHidden = true
    }

    func enqueue(monitorView: UIView) {
        show()
        containerView.addSubview(monitorView)
        monitorViews.append(monitorView)
        relayoutMonitorViews()
    }

    func dequeue(monitorView: UIView) {
        for index in 0..<monitorViews.count {
            if monitorViews[index] == monitorView {
                monitorView.removeFromSuperview()
                monitorViews.remove(at: index)
                break
            }
        }
        relayoutMonitorViews()
        if monitorViews.isEmpty {
            hide()
        }
    }

    private func relayoutMonitorViews() {
        guard !monitorViews.isEmpty else {
            return
        }
        let itemWidth = bounds.size.width/CGFloat(monitorViews.count)
        for (index, view) in monitorViews.enumerated() {
            view.frame = CGRect(x: itemWidth*CGFloat(index), y: 0, width: itemWidth, height: contentHeight)
        }
    }
}
