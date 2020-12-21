//
//  CandlePainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

class CandlePainter: CALayer, Painter {
    
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax) {
        guard !models.isEmpty else { return }
        let maxH = area.height
        let unitValue = maxH / minMax.distance
        
        let subLayer = CandlePainter()
        subLayer.frame = area
        subLayer.contentsScale = UIScreen.main.scale
        
        for (i, m) in models.enumerated() {
            let w = KLineGlobalVariable.lineWidth
            let x = CGFloat(i) * (w + KLineGlobalVariable.lineGap)
            let centerX = x + w / 2 - KLineGlobalVariable.lineGap / 2
            let highPoint = CGPoint(x: centerX, y: maxH - (CGFloat(m.high) - minMax.min) * unitValue)
            let lowPoint = CGPoint(x: centerX, y: maxH - (CGFloat(m.low) - minMax.min) * unitValue)
            
            // 开收
            let h = CGFloat(abs(m.open - m.close)) * unitValue
            let y = maxH - (.maximum(CGFloat(m.open), CGFloat(m.close)) - minMax.min) * unitValue
            
            let path = UIBezierPath(rect: CGRect(x: x, y: y, width: w - KLineGlobalVariable.lineGap, height: h))
            path.move(to: lowPoint)
            path.addLine(to: CGPoint(x: centerX, y: y + h))
            path.move(to: highPoint)
            path.addLine(to: CGPoint(x: centerX, y: y))
            
            let l = CAShapeLayer()
            l.contentsScale = UIScreen.main.scale
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
        
        var minAssert = models[0].low
        var maxAssert = models[0].high
        
        for m in models {
            maxAssert = .maximum(m.high, maxAssert)
            minAssert = .minimum(m.low, minAssert)
        }
        return KLineMinMax(min: CGFloat(minAssert), max: CGFloat(maxAssert))
    }
}


