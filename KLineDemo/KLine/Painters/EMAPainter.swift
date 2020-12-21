//
//  EMAPainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

class EMAPainter: CALayer, Painter {
    
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax) {
        guard !models.isEmpty else { return }
        let maxH = area.height
        let unitValue = maxH / minMax.distance
        
        let subLayer = EMAPainter()
        subLayer.frame = area
        let path1 = UIBezierPath()
        let path2 = UIBezierPath()
        
        for (i, m) in models.enumerated() {
            let w = KLineGlobalVariable.lineWidth
            let x = CGFloat(i) * (w + KLineGlobalVariable.lineGap)
            let point1 = CGPoint(x: x + w / 2, y: maxH - (CGFloat(m.ema.ema1) - minMax.min) * unitValue)
            let point2 = CGPoint(x: x + w / 2, y: maxH - (CGFloat(m.ema.ema2) - minMax.min) * unitValue)
            if i == 0 {
                path1.move(to: point1)
                path2.move(to: point2)
            } else {
                path1.addLine(to: point1)
                path2.addLine(to: point2)
            }
        }
        
        let l1 = CAShapeLayer()
        l1.path = path1.cgPath
        l1.lineWidth = KLineGlobalVariable.shadowLineWidth
        l1.strokeColor = UIColor.line1Color.cgColor
        l1.fillColor = UIColor.clear.cgColor
        subLayer.addSublayer(l1)
        
        let l2 = CAShapeLayer()
        l2.path = path2.cgPath
        l2.lineWidth = KLineGlobalVariable.shadowLineWidth
        l2.strokeColor = UIColor.line2Color.cgColor
        l2.fillColor = UIColor.clear.cgColor
        subLayer.addSublayer(l2)
        
        layer.addSublayer(subLayer)
    }
    
    static func getText(model: KLine) -> NSAttributedString {
        return model.v_ema
    }
    
    static func getMinMaxValue(models: [KLine]) -> KLineMinMax {
        guard !models.isEmpty else { return KLineMinMax(min: 0, max: 0) }
        
        var minAssert = 999999999999.0
        var maxAssert = 0.0
        
        for m in models {
            maxAssert = .maximum(m.ema.ema1, .maximum(m.ema.ema2, maxAssert))
            minAssert = .minimum(m.ema.ema1, .minimum(m.ema.ema2, minAssert))
        }
        return KLineMinMax(min: CGFloat(minAssert), max: CGFloat(maxAssert))
    }
}

