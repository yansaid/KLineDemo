//
//  KLineRoot.swift
//  YourMoney
//
//  Created by Yan on 2020/12/2.
//

import Foundation

struct KLineRoot {
    var models = [KLine]()
    
    static func newRoot(arr: [[Double]]) -> Self? {
        
        var group = KLineRoot()
        var mArr = [KLine]()
        var index = 0
        for i in 0 ..< arr.count {
            let item = arr[arr.count - i - 1]
            guard item.count > 5 else { return nil }
            
            let model = KLine(index: index, timestamp: item[5], open: item[0], close: item[1], high: item[2], low: item[3], volume: item[4])
            mArr.append(model)
            index += 1
        }
        
        group.models = mArr
        group.calculateIndicators(key: .MACD)
        group.calculateIndicators(key: .MA)
        group.calculateIndicators(key: .KDJ)
        group.calculateIndicators(key: .RSI)
        group.calculateIndicators(key: .BOLL)
        group.calculateIndicators(key: .WR)
        group.calculateIndicators(key: .EMA)
        group.calculateNeedDrawTimeModel()
        return group
    }
    
    func calculateNeedDrawTimeModel() {
        let gap = 50 / KLineGlobalVariable.kLineWidth() + KLineGlobalVariable.lineGap
        for i in 0 ..< models.count {
            models[i].isDrawTime = (i % Int(gap)) == 0
        }
    }
    
    func calculateIndicators(key: KLineIncicator) {
        switch (key) {
        case .MA:
            KLine.MA.calculate(datas: models, params: [10, 30, 60])
        case .MACD:
            KLine.MACD.calculate(datas: models, params: [12, 26, 9])
        case .KDJ:
            KLine.KDJ.calculate(datas: models, params: [9, 3, 3])
        case .RSI:
            KLine.RSI.calculate(datas: models, params: [6, 12, 24])
        case .WR:
            KLine.WR.calculate(datas: models, params: [6, 10])
        case .EMA:
            KLine.EMA.calculate(datas: models, params: [7, 30])
        case .BOLL:
            KLine.BOLL.calculate(datas: models, params: [20, 2])
        }
    }
}
