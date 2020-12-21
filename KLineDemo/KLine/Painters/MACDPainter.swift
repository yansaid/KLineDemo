//
//  MACDPainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

class MACDPainter: CALayer, Painter {
    
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax) {
        guard !models.isEmpty else { return }
        let maxH = area.height
        let unitValue = maxH / minMax.distance
        
        let subLayer = MACDPainter()
        subLayer.frame = area
        layer.addSublayer(subLayer)
        
        let path1 = UIBezierPath()
        let path2 = UIBezierPath()
        
        for (i, m) in models.enumerated() {
            let w = KLineGlobalVariable.lineWidth
            let x = CGFloat(i) * (w + KLineGlobalVariable.lineGap)
            let h = abs(CGFloat(m.macd.macd)) * unitValue
            var y: CGFloat = 0.0
            
            if m.macd.macd > 0 {
                y = maxH - h + minMax.min * unitValue
            } else {
                y = maxH + minMax.min * unitValue
            }
            
            let path = UIBezierPath(rect: CGRect(x: x, y: y, width: w - KLineGlobalVariable.lineGap, height: h))
            let l = CAShapeLayer()
            l.path = path.cgPath
            l.lineWidth = KLineGlobalVariable.shadowLineWidth
            l.strokeColor = m.macd.macd < 0 ? UIColor.upColor.cgColor : UIColor.downColor.cgColor
            l.fillColor = m.macd.macd < 0 ? UIColor.upColor.cgColor : UIColor.downColor.cgColor
            subLayer.addSublayer(l)
            
            let centerX = x + w / 2
            
            let point1 = CGPoint(x: centerX, y: maxH - (CGFloat(m.macd.dea) - minMax.min) * unitValue)
            let point2 = CGPoint(x: centerX, y: maxH - (CGFloat(m.macd.diff) - minMax.min) * unitValue)
            if point1.y > 100 || point2.y > 100 {
                print("p1.y: \(point1.y), p2.y: \(point2.y), maxH: \(maxH)")
            }
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
    }
    
    static func getText(model: KLine) -> NSAttributedString {
        return model.v_macd
    }
    
    static func getMinMaxValue(models: [KLine]) -> KLineMinMax {
        guard !models.isEmpty else { return KLineMinMax(min: 0, max: 0) }
        
        var maxAssert = 0.0
        
        for m in models {
            maxAssert = .maximum(abs(m.macd.diff), .maximum(abs(m.macd.dea), .maximum(abs(m.macd.macd), maxAssert)))
        }
        return KLineMinMax(min: -CGFloat(maxAssert), max: CGFloat(maxAssert))
    }
}

