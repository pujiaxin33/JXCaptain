//
//  MonitorView.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class MonitorConsoleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(type: MonitorType, value: Double) {
        switch type {
        case .fps:
            let percent = CGFloat(value/60)
            let valueColor = UIColor(hue: 0.27 * (percent - 0.2), saturation: 1, brightness: 0.9, alpha: 1)
            let contentText = "\(round(value)) FPS"
            let attrText = NSMutableAttributedString(string: contentText, attributes: [.foregroundColor : valueColor, .font : UIFont.systemFont(ofSize: 16)])
            attrText.addAttribute(.foregroundColor, value: UIColor.white, range: NSString(string: contentText).range(of: "FPS"))
            attributedText = attrText
        case .memory:
            let percent = CGFloat(value/350)
            let valueColor = color(percent: percent)
            let contentText = String(format: "%.1f M", value)
            let attrText = NSMutableAttributedString(string: contentText, attributes: [.foregroundColor : valueColor, .font : UIFont.systemFont(ofSize: 16)])
            attrText.addAttribute(.foregroundColor, value: UIColor.white, range: NSString(string: contentText).range(of: "M"))
            attributedText = attrText
        case .cpu:
            let percent = CGFloat(value/100)
            let valueColor = color(percent: percent)
            let contentText = String(format: "%.lf%% CPU", round(value))
            let attrText = NSMutableAttributedString(string: contentText, attributes: [.foregroundColor : valueColor, .font : UIFont.systemFont(ofSize: 16)])
            attrText.addAttribute(.foregroundColor, value: UIColor.white, range: NSString(string: contentText).range(of: "CPU"))
            attributedText = attrText
        default: break
        }
    }

    private func color(percent: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        let one: CGFloat = 255 + 255
        if percent < 0.5 {
            r = one * percent
            g = 255
        }else if percent > 0.5 {
            g = 255 - ((percent - 0.5) * one)
            r = 255
        }
        return UIColor(red: r/255, green: g/255, blue: 0, alpha: 1)
    }
}
