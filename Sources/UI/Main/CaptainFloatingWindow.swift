//
//  floatingWindow.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class CaptainFloatingWindow: UIWindow {
    let floatingVC: CaptainFloatingViewController

    override init(frame: CGRect) {
        floatingVC = CaptainFloatingViewController()
        super.init(frame: UIScreen.main.bounds)

        windowLevel = UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue - 1)
        rootViewController = floatingVC
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .clear
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == floatingVC.view {
            return nil
        }
        return view
    }
}
