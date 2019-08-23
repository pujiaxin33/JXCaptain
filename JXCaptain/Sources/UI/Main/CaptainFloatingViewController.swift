//
//  CaptainFloatingViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class CaptainFloatingViewController: BaseViewController {
    var shieldButton: UIButton!
    let shieldWidth: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        shieldButton = UIButton(type: .custom)
        shieldButton.setImage(ImageManager.imageWithName("icon_shield"), for: .normal)
        shieldButton.layer.shadowOpacity = 0.6
        shieldButton.layer.shadowRadius = 3
        shieldButton.layer.shadowOffset = CGSize.zero
        shieldButton.frame = CGRect(x: 12, y: (view.bounds.size.height - shieldWidth)/2, width: shieldWidth, height: shieldWidth)
        shieldButton.addTarget(self, action: #selector(shieldButtonDidClick), for: .touchUpInside)
        view.addSubview(shieldButton)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(processPan(_:)))
        shieldButton.addGestureRecognizer(pan)
    }

    @objc func shieldButtonDidClick() {
        present(UINavigationController(rootViewController: SoldierListViewController()), animated: true, completion: nil)
    }

    @objc func processPan(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: view)
        let screenEdge: CGFloat = 12
        var screenTopEdge: CGFloat = 20
        var screenBottomEdge: CGFloat = 12
        if #available(iOS 11.0, *) {
            let safeAreaInsets = Captain.default.floatingWindow.safeAreaInsets
            if safeAreaInsets.top > 0 {
                screenTopEdge = safeAreaInsets.top
            }
            if safeAreaInsets.bottom > 0 {
                screenBottomEdge = safeAreaInsets.bottom
            }
        }
        let minCenterX = screenEdge + shieldWidth/2
        let maxCenterX = view.bounds.size.width - screenEdge - shieldWidth/2
        let minCenterY = screenTopEdge + shieldWidth/2
        let maxCenterY = view.bounds.size.height - screenBottomEdge - shieldWidth/2
        let centerX = min(maxCenterX, max(minCenterX, point.x))
        let centerY = min(maxCenterY, max(minCenterY, point.y))
        if gesture.state == .began {
            UIView.animate(withDuration: 0.1) {
                self.shieldButton.center = point
            }
        }else if gesture.state == .changed {
            shieldButton.center = CGPoint(x:centerX , y: centerY)
        }else if gesture.state == .ended || gesture.state == .cancelled {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                var center = self.shieldButton.center
                if center.x > self.view.bounds.size.width/2 {
                    center.x = maxCenterX
                }else {
                    center.x = minCenterX
                }
                self.shieldButton.center = center
            }, completion: nil)
        }
    }

}
