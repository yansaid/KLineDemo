//
//  VerticalTextPainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

class VerticalTextPainter: CALayer, VTextPainter {
    static func draw(to layer: CALayer, area: CGRect, minMaxModel: KLineMinMax) {
        let maxH = area.height
        guard maxH > 0 else { return }
        
        let subLayer = VerticalTextPainter()
        subLayer.frame = area
        layer.addSublayer(subLayer)
        
        var count = Int(maxH / 40)
        count += 1
        let lineH = UIFont.systemFont(ofSize: 12).lineHeight
        let textGap = (maxH - lineH) / (CGFloat(count) - 1)
        let decinmalGap = minMaxModel.distance / CGFloat(count - 1)
        
        for i in 0 ..< count {
            let layer = CATextLayer()
            let number = minMaxModel.max - CGFloat(i) * decinmalGap
            var text = ""
            if number >= 1e8 {
                text = String(format: "%.2f亿", number / 1e8)
            } else if number >= 1e4 {
                text = String(format: "%.2f万", number / 1e4)
            } else if number >= 10 {
                text = String(format: "%.2f", number)
            } else {
                text = String(format: "%.3f", number)
            }
            
            layer.string = text
            layer.alignmentMode = .center
            layer.fontSize = 11
            layer.foregroundColor = UIColor.gray.cgColor
            layer.frame = CGRect(x: 0, y: CGFloat(i) * textGap, width: area.width, height: lineH)
            layer.contentsScale = UIScreen.main.scale
            subLayer.addSublayer(layer)
        }
    }
}



