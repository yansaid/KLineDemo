//
//  TimelinePainter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//
import UIKit

class TimelinePainter: CALayer, Painter {
    
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax) {
        guard !models.isEmpty else { return }
        let maxH = area.height
        let unitValue = maxH / minMax.distance
        
        let subLayer = TimelinePainter()
        subLayer.frame = area
        
        let path1 = UIBezierPath()
        var pointStart = CGPoint.zero
        var pointEnd = CGPoint.zero
        
        for (i, m) in models.enumerated() {
            let w = KLineGlobalVariable.lineWidth
            let x = CGFloat(i) * (w + KLineGlobalVariable.lineGap)
            let point1 = CGPoint(x: x + w / 2, y: maxH - (CGFloat(m.close) - minMax.min) * unitValue)
            if i == 0 {
                path1.move(to: point1)
                pointStart = point1
            } else {
                path1.addLine(to: point1)
            }
            
            if i == models.count - 1 {
                pointEnd = point1
            }
        }
        
        let l = CAShapeLayer()
        l.path = path1.cgPath
        l.lineWidth = KLineGlobalVariable.shadowLineWidth
        l.strokeColor = UIColor.timeLineLineColor.cgColor
        l.fillColor = UIColor.clear.cgColor
        subLayer.addSublayer(l)
        
        layer.addSublayer(subLayer)
        
        let maskLayer = CAShapeLayer()
        let path2 = path1.copy() as! UIBezierPath
        path2.addLine(to: CGPoint(x: pointEnd.x, y: maxH))
        path2.addLine(to: CGPoint(x: pointStart.x, y: maxH))
        path2.close()
        
        maskLayer.path = path2.cgPath
        let bgLayer = CAGradientLayer()
        bgLayer.frame = area
        bgLayer.colors = [UIColor(red: 0.3, green: 0.3, blue: 0.7, alpha: 0.5).cgColor, UIColor.clear.cgColor]
        bgLayer.locations = [0.3, 0.9]
        bgLayer.mask = maskLayer
        layer.addSublayer(bgLayer)
    }
    
    static func getMinMaxValue(models: [KLine]) -> KLineMinMax {
        guard !models.isEmpty else { return KLineMinMax(min: 0, max: 0) }
        
        var minAssert = 999999999999.0
        var maxAssert = 0.0
        
        for m in models {
            maxAssert = .maximum(m.close, maxAssert)
            minAssert = .minimum(m.close, minAssert)
        }
        return KLineMinMax(min: CGFloat(minAssert), max: CGFloat(maxAssert))
    }
}


