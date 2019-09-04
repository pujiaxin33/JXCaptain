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
    var newEventView: UIView!

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

        newEventView = UIView()
        newEventView.isHidden = true
        newEventView.backgroundColor = UIColor.red
        newEventView.layer.cornerRadius = 4
        newEventView.frame = CGRect(x: shieldButton.bounds.size.width - 8, y: 0, width: 8, height: 8)
        shieldButton.addSubview(newEventView)
        refreshNewEventView()

        let pan = UIPanGestureRecognizer(target: self, action: #selector(processPan(_:)))
        shieldButton.addGestureRecognizer(pan)

        NotificationCenter.default.addObserver(self, selector: #selector(soldierNewEventDidChange), name: .JXCaptainSoldierNewEventDidChange, object: nil)
        //FIXME:如果要保证当前的状态栏跟目标APP当前页面一直，可以不断触发setNeedsStatusBarAppearanceUpdate方法，但是经过测试会带来额外的6%CPU开销。
//        let link = CADisplayLink(target: self, selector: #selector(processLink))
//        link.add(to: RunLoop.current, forMode: .common)
    }

    @objc func processLink() {
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UIApplication.shared.keyWindow?.rootViewController?.topController() == self {
            return .default
        }else {
            return UIApplication.shared.keyWindow?.rootViewController?.topController()?.preferredStatusBarStyle ?? .default
        }
    }

    @objc func shieldButtonDidClick() {
        present(BaseNavigationController(rootViewController: SoldierListViewController()), animated: true, completion: nil)
    }

    @objc func soldierNewEventDidChange() {
        DispatchQueue.main.async {
            self.refreshNewEventView()
        }
    }

    func refreshNewEventView() {
        newEventView.isHidden = true
        for soldier in Captain.default.soldiers {
            if soldier.hasNewEvent {
                newEventView.isHidden = false
                break
            }
        }
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
