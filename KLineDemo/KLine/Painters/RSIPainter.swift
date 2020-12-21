//
//  RSIPainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

class RSIPainter: CALayer, Painter {
    
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax) {
        guard !models.isEmpty else { return }
        let maxH = area.height
        let unitValue = maxH / minMax.distance
        
        let subLayer = RSIPainter()
        subLayer.frame = area
        let path1 = UIBezierPath()
        let path2 = UIBezierPath()
        let path3 = UIBezierPath()
        
        for (i, m) in models.enumerated() {
            let w = KLineGlobalVariable.lineWidth
            let x = CGFloat(i) * (w + KLineGlobalVariable.lineGap)
            let point1 = CGPoint(x: x + w / 2, y: maxH - (CGFloat(m.rsi.rsi1) - minMax.min) * unitValue)
            let point2 = CGPoint(x: x + w / 2, y: maxH - (CGFloat(m.rsi.rsi2) - minMax.min) * unitValue)
            let point3 = CGPoint(x: x + w / 2, y: maxH - (CGFloat(m.rsi.rsi3) - minMax.min) * unitValue)
            if i == 0 {
                path1.move(to: point1)
                path2.move(to: point2)
                path3.move(to: point3)
            } else {
                path1.addLine(to: point1)
                path2.addLine(to: point2)
                path3.addLine(to: point3)
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
        
        let l3 = CAShapeLayer()
        l3.path = path3.cgPath
        l3.lineWidth = KLineGlobalVariable.shadowLineWidth
        l3.strokeColor = UIColor.line3Color.cgColor
        l3.fillColor = UIColor.clear.cgColor
        subLayer.addSublayer(l3)
        
        layer.addSublayer(subLayer)
    }
    
    static func getText(model: KLine) -> NSAttributedString {
        return model.v_rsi
    }
    
    static func getMinMaxValue(models: [KLine]) -> KLineMinMax {
        guard !models.isEmpty else { return KLineMinMax(min: 0, max: 0) }
        
        var minAssert = 999999999999.0
        var maxAssert = 0.0
        
        for m in models {
            maxAssert = .maximum(m.rsi.rsi3, .maximum(m.rsi.rsi2, .maximum(m.rsi.rsi1, maxAssert)))
            minAssert = .minimum(m.rsi.rsi3, .minimum(m.rsi.rsi2, .minimum(m.rsi.rsi1, minAssert)))
        }
        return KLineMinMax(min: CGFloat(minAssert), max: CGFloat(maxAssert))
    }
}
