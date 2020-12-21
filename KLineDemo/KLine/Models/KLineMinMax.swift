//
//  KLineMinMax.swift
//  YourMoney
//
//  Created by Yan on 2020/12/2.
//

import Foundation
import UIKit

struct KLineMinMax {
    var min: CGFloat
    var max: CGFloat
    
    var distance: CGFloat {
        return max - min
    }
    
    mutating func combine(m: KLineMinMax) {
        min = CGFloat.minimum(min, m.min)
        max = CGFloat.maximum(max, m.max)
    }
}
