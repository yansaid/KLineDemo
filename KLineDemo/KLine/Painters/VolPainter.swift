//
//  VolPainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

class VolPainter: CALayer, Painter {
    
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax) {
        guard !models.isEmpty else { return }
        let maxH = area.height
        let unitValue = maxH / minMax.distance
        
        let subLayer = VolPainter()
        subLayer.frame = area
        
        for (i, m) in models.enumerated() {
            let w = KLineGlobalVariable.lineWidth
            let x = CGFloat(i) * (w + KLineGlobalVariable.lineGap)
            let h = abs(CGFloat(m.volume) - minMax.min) * unitValue
            let path = UIBezierPath(rect: CGRect(x: x, y: maxH - h, width: w - KLineGlobalVariable.lineGap, height: h))
            let l = CAShapeLayer()
            l.path = path.cgPath
            l.lineWidth = KLineGlobalVariable.shadowLineWidth
            l.strokeColor = m.isUp ? UIColor.upColor.cgColor : UIColor.downColor.cgColor
            l.fillColor = m.isUp ? UIColor.upColor.cgColor : UIColor.downColor.cgColor
            subLayer.addSublayer(l)
        }
        layer.addSublayer(subLayer)
    }
    
    static func getMinMaxValue(models: [KLine]) -> KLineMinMax {
        guard !models.isEmpty else { return KLineMinMax(min: 0, max: 0) }
        
        let minAssert = 0.0
        var maxAssert = 0.0
        
        for m in models {
            maxAssert = .maximum(m.volume, maxAssert)
        }
        return KLineMinMax(min: CGFloat(minAssert), max: CGFloat(maxAssert))
    }
}

