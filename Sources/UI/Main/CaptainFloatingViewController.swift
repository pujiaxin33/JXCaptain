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
        shieldButton.setImage(Captain.default.logoImage, for: .normal)
        shieldButton.layer.shadowOpacity = 0.6
        shieldButton.layer.shadowColor = UIColor.black.cgColor
        shieldButton.layer.shadowRadius = 3
        shieldButton.layer.shadowOffset = CGSize.zero
        let screenEdgeInsets = Captain.default.screenEdgeInsets
        let y = screenEdgeInsets.top + (view.bounds.size.height - screenEdgeInsets.top - screenEdgeInsets.bottom - shieldWidth)/2
        shieldButton.frame = CGRect(x: screenEdgeInsets.left, y: y, width: shieldWidth, height: shieldWidth)
        shieldButton.addTarget(self, action: #selector(shieldButtonDidClick), for: .touchUpInside)
        view.addSubview(shieldButton)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(processPan(_:)))
        shieldButton.addGestureRecognizer(pan)
    }

    @objc func shieldButtonDidClick() {
        present(BaseNavigationController(rootViewController: SoldierListViewController()), animated: true, completion: nil)
    }

    @objc func processPan(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: view)
        let screenEdgeInsets = Captain.default.screenEdgeInsets
        let minCenterX = screenEdgeInsets.left + shieldWidth/2
        let maxCenterX = view.bounds.size.width - screenEdgeInsets.right - shieldWidth/2
        let minCenterY = screenEdgeInsets.top + shieldWidth/2
        let maxCenterY = view.bounds.size.height - screenEdgeInsets.bottom - shieldWidth/2
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
