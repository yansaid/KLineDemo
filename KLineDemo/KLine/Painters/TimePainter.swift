//
//  TimePainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

class TimePainter: CALayer, Painter {
    
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax) {
        let maxH = area.height
        guard !models.isEmpty, maxH > 0 else { return }
        
        let subLayer = TimePainter()
        subLayer.backgroundColor = UIColor.assistBackgroundColor.cgColor
        subLayer.frame = area
        layer.addSublayer(subLayer)
        
        let w = KLineGlobalVariable.lineWidth
        for (i, m) in models.enumerated() {
            if m.isDrawTime {
                let x = CGFloat(i) * (w + KLineGlobalVariable.lineGap)
                let y = (maxH - UIFont.systemFont(ofSize: 12).lineHeight) / 2
                
                let textLayer = CATextLayer()
                textLayer.string = m.v_hhmm;
                textLayer.alignmentMode = .center
                textLayer.fontSize = 12
                textLayer.foregroundColor = UIColor.gray.cgColor
                textLayer.frame = CGRect(x: x - 50, y: y, width: 100, height: maxH)
                textLayer.contentsScale = UIScreen.main.scale
                
                subLayer.addSublayer(textLayer)
            }
        }
    }
}

