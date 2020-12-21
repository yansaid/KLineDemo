//
//  UIColorKLine.swift
//  YourMoney
//
//  Created by Yan on 2020/12/2.
//

import UIKit

extension UIColor {
    static func color(rgbHex: UInt32) -> UIColor {
        let r = Int((rgbHex >> 16) & 0xFF)
        let g = Int((rgbHex >> 8) & 0xFF)
        let b = Int((rgbHex) & 0xFF)
        
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
    
    /// 所有图表的背景颜色
    static var backgroundColor: UIColor {
        return color(rgbHex: 0x181c20)
    }
    /// 辅助背景色
    static var assistBackgroundColor: UIColor {
        return color(rgbHex: 0x1d2227)
    }
    /// 涨的颜色
    static var upColor: UIColor {
        return color(rgbHex: 0xff5353)
    }
    /// 跌的颜色
    static var downColor: UIColor {
        return color(rgbHex: 0x00b07c)
    }
    /// 主文字颜色
    static var mainTextColor: UIColor {
        return color(rgbHex: 0xe1e2e6)
    }
    /// 分时线的颜色
    static var timeLineLineColor: UIColor {
        return .white
    }
    
    static var longPressLineColor: UIColor {
        return color(rgbHex: 0xe1e2e6)
    }
    
    static var line1Color: UIColor {
        return color(rgbHex: 0xff783c)
    }
    
    static var line2Color: UIColor {
        return color(rgbHex: 0x49a5ff)
    }
    
    static var line3Color: UIColor {
        return .purple
    }
}
