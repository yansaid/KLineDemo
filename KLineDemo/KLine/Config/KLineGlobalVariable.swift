//
//  KLineGlobalVariable.swift
//  YourMoney
//
//  Created by Yan on 2020/12/2.
//

import Foundation
import UIKit

struct KLineGlobalVariable {
    /**
     *  K线图的宽度，默认20
     */
    static var lineWidth: CGFloat = 4
    /**
     *  K线图的间隔，默认1
     */
    static var lineGap: CGFloat = 2
    /**
     *  MainView的高度占比,默认为0.5
     */
    static var mainViewRadio: CGFloat = 0.5
    /**
     *  VolumeView的高度占比,默认为0.2
     */
    static var volumeViewRadio: CGFloat = 0.2
    /**
     *  K线最大的宽度
     */
    static var lineMaxWidth: CGFloat = 20
    /**
     *  K线图最小的宽度
     */
    static var lineMinWidth: CGFloat = 4
    /**
     *  K线图缩放界限
     */
    static var scaleBound: CGFloat = 0.02

    /**
     *  K线的缩放因子
     */
    static var scaleFactor: CGFloat = 0.07

    /**
     *  长按时的线的宽度
     */
    static var longPressVerticalViewWidth: CGFloat = 0.5

    /**
     *  上下影线宽度
     */
    static var shadowLineWidth: CGFloat = 1
    
    /**
     *  K线图Y的View的宽度
     */
    static var priceViewWidth: CGFloat = 47
    
    /**
     *  K线图的宽度，默认20
     */
    static func kLineWidth() -> CGFloat {
        return lineWidth
    }
    
    static func setKLine(width: CGFloat) {
        if width > lineMaxWidth {
            lineWidth = lineMaxWidth
        } else if width < lineMinWidth {
            lineWidth = lineMinWidth
        } else {
            lineWidth = width
        }
    }
    
    /**
     *  K线图的间隔，默认1
     */
    static func kLineGap() -> CGFloat { lineGap }
    static func setKLine(gap: CGFloat) {
        lineGap = gap
    }
    
    /**
     *  MainView的高度占比,默认为0.5
     */
    static func kLineMainViewRadio() -> CGFloat { mainViewRadio }
    static func setKLine(mainViewRadio: CGFloat) {
        self.mainViewRadio = mainViewRadio
    }
    
    /**
     *  VolumeView的高度占比,默认为0.2
     */
    static func kLineVolumeViewRadio() -> CGFloat { volumeViewRadio }
    static func setKLine(volumeViewRadio: CGFloat) {
        self.volumeViewRadio = volumeViewRadio
    }
}

enum KLineType: Int {
    case kLine = 1
    case timeLine
    case indicator
}
