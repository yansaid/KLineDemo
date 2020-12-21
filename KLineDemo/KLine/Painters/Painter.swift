//
//  Painter.swift
//  YourMoney
//
//  Created by Yan on 2020/12/3.
//

import UIKit

protocol Painter {
    static func draw(to layer: CALayer, area: CGRect, models: [KLine], minMax: KLineMinMax)
    static func getMinMaxValue(models: [KLine]) -> KLineMinMax
    static func getText(model: KLine) -> NSAttributedString
}

extension Painter {
    static func getMinMaxValue(models: [KLine]) -> KLineMinMax {
        return KLineMinMax(min: 0, max: 0)
    }
    
    static func getText(model: KLine) -> NSAttributedString {
        return NSAttributedString()
    }
}

protocol VTextPainter {
    static func draw(to layer: CALayer, area: CGRect, minMaxModel: KLineMinMax)
}
