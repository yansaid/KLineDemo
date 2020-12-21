//
//  KLine.swift
//  YourMoney
//
//  Created by Yan on 2020/12/2.
//

import Foundation
import UIKit

class KLine {
    var index: Int
    
    var prevModel: KLine?
    
    var timestamp: Double
    var open: Double
    var close: Double
    var high: Double
    var low: Double
    var volume: Double
    
    var isDrawTime = false
    
    var macd: MACD!
    var kdj: KDJ!
    var ma: MA!
    var ema: EMA!
    var rsi: RSI!
    var boll: BOLL!
    var wr: WR!
    
    init(index: Int, timestamp: Double, open: Double, close: Double, high: Double, low: Double, volume: Double) {
        self.index = index
        self.timestamp = timestamp
        self.open = open
        self.close = close
        self.high = high
        self.low = low
        self.volume = volume
    }
    
    lazy var v_date: String = {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }()
    
    lazy var v_hhmm: String = {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }()
    
    lazy var v_price: NSAttributedString = {
        return NSAttributedString(string: String(format:" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", v_date, open, high, low, close),
                                  attributes: [.foregroundColor: UIColor.gray])
    }()
    
    lazy var v_ma: NSAttributedString = {
        let str1 = NSAttributedString(string: String(format:" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", v_date, open, high, low, close),
                                      attributes: [.foregroundColor: UIColor.gray])
        let str2 = NSAttributedString(string: String(format: " MA10：%.3f ", ma.ma1),
                                      attributes: [.foregroundColor: UIColor.line1Color])
        let str3 = NSAttributedString(string: String(format: " MA30：%.3f ", ma.ma2),
                                      attributes: [.foregroundColor: UIColor.line2Color])
        let str4 = NSAttributedString(string: String(format: " MA60：%.3f ", ma.ma3),
                                      attributes: [.foregroundColor: UIColor.line3Color])
        let mStr = NSMutableAttributedString(attributedString: str1)
        mStr.append(str2)
        mStr.append(str3)
        mStr.append(str4)
        return mStr
    }()
    
    lazy var v_ema: NSAttributedString = {
        let str1 = NSAttributedString(string: String(format:" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", v_date, open, high, low, close),
                                      attributes: [.foregroundColor: UIColor.gray])
        let str2 = NSAttributedString(string: String(format: " EMA7：%.3f ", ema.ema1),
                                      attributes: [.foregroundColor: UIColor.line1Color])
        let str3 = NSAttributedString(string: String(format: " EMA30：%.3f ", ema.ema2),
                                      attributes: [.foregroundColor: UIColor.line2Color])
        let mStr = NSMutableAttributedString(attributedString: str1)
        mStr.append(str2)
        mStr.append(str3)
        return mStr
    }()
    
    lazy var v_boll: NSAttributedString = {
        let str1 = NSAttributedString(string: String(format:" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", v_date, open, high, low, close),
                                      attributes: [.foregroundColor: UIColor.gray])
        let str2 = NSAttributedString(string: String(format: " UP：%.3f ", boll.up),
                                      attributes: [.foregroundColor: UIColor.line1Color])
        let str3 = NSAttributedString(string: String(format: " MID：%.3f ", boll.mid),
                                      attributes: [.foregroundColor: UIColor.line2Color])
        let str4 = NSAttributedString(string: String(format: " LOW：%.3f ", boll.low),
                                      attributes: [.foregroundColor: UIColor.line3Color])
        let mStr = NSMutableAttributedString(attributedString: str1)
        mStr.append(str2)
        mStr.append(str3)
        mStr.append(str4)
        return mStr
    }()
    
    lazy var v_volume: NSAttributedString = {
        return NSAttributedString(string: String(format:" 成交量：%.0f", volume),
                                  attributes: [.foregroundColor: UIColor.gray])
    }()
    
    lazy var v_macd: NSAttributedString = {
        let str1 = NSAttributedString(string: " MACD(12,26,9)：",
                                      attributes: [.foregroundColor: UIColor.gray])
        let str2 = NSAttributedString(string: String(format: " DIFF：%.3f ", macd.diff),
                                      attributes: [.foregroundColor: UIColor.line1Color])
        let str3 = NSAttributedString(string: String(format: " DEA：%.3f ", macd.dea),
                                      attributes: [.foregroundColor: UIColor.line2Color])
        let str4 = NSAttributedString(string: String(format: " MACD：%.3f ", macd.macd),
                                      attributes: [.foregroundColor: UIColor.line3Color])
        let mStr = NSMutableAttributedString(attributedString: str1)
        mStr.append(str2)
        mStr.append(str3)
        mStr.append(str4)
        return mStr
    }()
    
    lazy var v_kdj: NSAttributedString = {
        let str1 = NSAttributedString(string: " KDJ(9,3,3)：",
                                      attributes: [.foregroundColor: UIColor.gray])
        let str2 = NSAttributedString(string: String(format: " K：%.3f ", kdj.k),
                                      attributes: [.foregroundColor: UIColor.line1Color])
        let str3 = NSAttributedString(string: String(format: " D：%.3f ", kdj.d),
                                      attributes: [.foregroundColor: UIColor.line2Color])
        let str4 = NSAttributedString(string: String(format: " J：%.3f ", kdj.j),
                                      attributes: [.foregroundColor: UIColor.line3Color])
        let mStr = NSMutableAttributedString(attributedString: str1)
        mStr.append(str2)
        mStr.append(str3)
        mStr.append(str4)
        return mStr
    }()
    
    lazy var v_rsi: NSAttributedString = {
        let str1 = NSAttributedString(string: " RSI(6,12,24)：",
                                      attributes: [.foregroundColor: UIColor.gray])
        let str2 = NSAttributedString(string: String(format: " RSI6：%.3f ", rsi.rsi1),
                                      attributes: [.foregroundColor: UIColor.line1Color])
        let str3 = NSAttributedString(string: String(format: " RSI12：%.3f ", rsi.rsi2),
                                      attributes: [.foregroundColor: UIColor.line2Color])
        let str4 = NSAttributedString(string: String(format: " RSI24：%.3f ", rsi.rsi3),
                                      attributes: [.foregroundColor: UIColor.line3Color])
        let mStr = NSMutableAttributedString(attributedString: str1)
        mStr.append(str2)
        mStr.append(str3)
        mStr.append(str4)
        return mStr
    }()
    
    lazy var v_wr: NSAttributedString = {
        let str1 = NSAttributedString(string: " WR(6,10)：",
                                      attributes: [.foregroundColor: UIColor.gray])
        let str2 = NSAttributedString(string: String(format: " WR6：%.3f ", macd.diff),
                                      attributes: [.foregroundColor: UIColor.line1Color])
        let str3 = NSAttributedString(string: String(format: " WR10：%.3f ", macd.dea),
                                      attributes: [.foregroundColor: UIColor.line2Color])
        let mStr = NSMutableAttributedString(attributedString: str1)
        mStr.append(str2)
        mStr.append(str3)
    
        return mStr
    }()
    
    var isUp: Bool {
        if close == open {
            return true
        }
        return close > open
    }
    
    /**
     * 12, 26, 9
     *
     * 计算macd指标,快速和慢速移动平均线的周期分别取12和26
     *
     * @method MACD
     * @param datas 计算数据
     *
     */
    struct MACD {
        var diff: Double
        var dea: Double
        var macd: Double
        
        static func emaWithLastEma(lastEma: Double, close: Double, day: Int) -> Double {
            let a = 2.0 / Double(day + 1)
            return a * close + (1 - a) * lastEma
        }
        
        static func deaWithLasDea(lasDea: Double, curDiff: Double) -> Double {
            return deaWithLasDea(lasDea: lasDea, curDiff: curDiff, day: 9)
        }
        
        static func deaWithLasDea(lasDea: Double, curDiff: Double, day: Int) -> Double {
            let a = 2.0 / Double(day + 1)
            return a * curDiff + (1 - a) * lasDea
        }
        
        static func calculate(datas: [KLine], params:[Int]) {
            guard params.count == 3 else { return }
            var ema12 = [Double]()
            var ema26 = [Double]()
            var diffs = [Double]()
            var deas = [Double]()
            var bars = [Double]()
            
            let p1 = params[0]
            let p2 = params[1]
            let p3 = params[2]
            
            for i in 0 ..< datas.count {
                let t = datas[i]
                let c = t.close
                if i == 0 {
                    ema12.append(c)
                    ema26.append(c)
                    deas.append(0)
                } else {
                    ema12.append(emaWithLastEma(lastEma: ema12[i - 1], close: c, day: p1))
                    ema26.append(emaWithLastEma(lastEma: ema26[i - 1], close: c, day: p2))
                }
                diffs.append(ema12[i] - ema26[i])
                if i != 0 {
                    deas.append(deaWithLasDea(lasDea: deas[i - 1], curDiff: diffs[i], day: p3))
                }
                bars.append((diffs[i] - deas[i]) * 2)
            }
            
            for i in 0 ..< datas.count {
                let obj = datas[i]
                obj.macd = MACD(diff: diffs[i], dea: deas[i], macd: bars[i])
            }
        }
    }
    
    /**
     * 9,3,3
     * 计算kdj指标,rsv的周期为9日
     *
     * @method KDJ
     * @param datas datas
     * 二维数组类型，其中内层数组包含三个元素值，第一个值表示当前Tick的最高价格，第二个表示当前Tick的最低价格，第三个表示当前Tick的收盘价格
     */
    struct KDJ {
        var k: Double
        var d: Double
        var j: Double
        
        static func calculate(datas: [KLine], params:[Int]) {
            guard params.count == 3 else { return }
            
            let days = params[0]
            var nineDaysDatas = [KLine]()
            let m1 = 1.0 / Double(params[1])
            let m2 = 1.0 / Double(params[2])
            
            var rsvs = [Double]()
            var ks = [Double]()
            var ds = [Double]()
            var js = [Double]()
            
            for i in 0 ..< datas.count {
                let t = datas[i]
                let c = t.close
                nineDaysDatas.append(t)
                var max = 0.0
                var min = Double.infinity
                for mn in nineDaysDatas {
                    max = .maximum(mn.high, max)
                    min = .minimum(mn.low, min)
                }
                
                if (max == min) {
                    rsvs.append(0)
                } else {
                    let v = ((c - min) / (max - min) * 100.0)
                    rsvs.append(v)
                }
                if nineDaysDatas.count == days {
                    nineDaysDatas.removeFirst()
                }
                if (i == 0) {
                    let k = rsvs[i]
                    ks.append(k)
                    let d = k
                    ds.append(d)
                    let j = 3.0 * k - 2.0 * d
                    js.append(j)
                } else {
                    let k = (1 - m1) * ks[i - 1] + m1 * rsvs[i]
                    ks.append(k)
                    let d = (1 - m2) * ds[i - 1] + m2 * k
                    ds.append(d)
                    let j = 3.0 * k - 2.0 * d
                    js.append(j)
                }
            }
            
            for i in 0 ..< datas.count {
                let obj = datas[i]
                obj.kdj = KDJ(k: ks[i], d: ds[i], j: js[i])
            }
        }
    }
    
    /**
     * 计算移动平均线指标, ma的周期为days
     
     @param datas 数据
     @param params MA计算参数
     */
    struct MA {
        var ma1: Double
        var ma2: Double
        var ma3: Double
        
        static func calculate(datas: [KLine], params:[Int]) {
            guard !params.isEmpty else { return }
            
            let days = params
            var result = [Int: [Double]]()
            var paramData = [Int: [Double]]()
            
            for i in 0 ..< datas.count {
                let t = datas[i]
                let c = t.close
                
                for d in days {
                    let ma = d
                    var mas = result[ma] ?? []
                    var nma = paramData[ma] ?? []
                    nma.append(c)
                    
                    if nma.count == d {
                        var nowMa = 0.0
                        for n in nma {
                            nowMa += n
                        }
                        nowMa /= Double(d)
                        mas.append(nowMa)
                        nma.removeFirst()
                        
                    } else {
                        var nowMa = 0.0
                        for n in nma {
                            nowMa += n
                        }
                        nowMa /= Double(nma.count)
                        mas.append(nowMa)
                    }
                    
                    result[ma] = mas
                    paramData[ma] = nma
                }
            }
            
            for i in 0 ..< datas.count {
                let obj = datas[i]
                obj.ma = MA(ma1: result[10]![i], ma2: result[30]![i], ma3:result[60]![i])
            }
        }
    }
    
    /**
     *
     * 计算rsi指标,分别返回以6日，12日，24日为参考基期的RSI值
     *
     * @method RSI
     * @param datas
     * 一维数组类型，每个元素为当前Tick的收盘价格
     */
    struct RSI {
        var rsi1: Double
        var rsi2: Double
        var rsi3: Double
        
        static func calculate(datas: [KLine], params:[Int]) {
            guard params.count != 0 else { return }
            
            var lastClosePx = datas[0].close
            let days = params
            var result = [Int: [Double]]()
            
            for i in 0 ..< datas.count {
                let t = datas[i]
                let c = t.close
                
                let m = max(c - lastClosePx, 0)
                let a = abs(c - lastClosePx)
                
                var lastSm = 0.0
                var lastSa = 0.0
                
                for d in days {
                    let rsi = d
                    if result[rsi] == nil {
                        result[rsi] = [0.0]
                    } else {
                        lastSm = (m + (Double(d) - 1) * lastSm) / Double(d)
                        lastSa = (a + (Double(d) - 1) * lastSa) / Double(d)
                        var ary = result[rsi]
                        if lastSa != 0 {
                            ary!.append(lastSm / lastSa * 100.0)
                        } else {
                            ary!.append(0)
                        }
                        result[rsi] = ary
                    }
                }
                lastClosePx = c
            }
            
            for i in 0 ..< datas.count {
                let obj = datas[i]
                obj.rsi = RSI(rsi1: result[6]![i], rsi2: result[12]![i], rsi3:result[24]![i])
            }
        }
    }
    /**
     *
     * 计算boll指标,ma的周期为20日
     *
     * @method BOLL
     * @param datas datas
     * 一维数组类型，每个元素为当前Tick的收盘价格
     */
    struct BOLL {
        var up: Double
        var mid: Double
        var low: Double
        
        static func calculate(datas: [KLine], params:[Int]) {
            guard params.count == 2 else { return }
            
            let maDays = params[0]
            let k = Double(params[1])
            
            var ups = [Double]()
            var mas = [Double]()
            var lows = [Double]()
            var nma = [Double]()
            
            for i in 0 ..< datas.count {
                let t = datas[i]
                let c = t.close
                nma.append(c)
                
                if nma.count == maDays {
                    let mb = mas[i - 1]
                    var nowMa = 0.0
                    var sumMd = 0.0
                    for n in nma {
                        nowMa += n
                        sumMd += pow(n - mb, 2)
                    }
                    
                    nowMa /= Double(maDays)
                    mas.append(nowMa)
                    nma.removeFirst()
                    
                    let md = sqrt(sumMd / Double(maDays))
                    let up = mb + k * md
                    let dn = mb - k * md
                    ups.append(up)
                    lows.append(dn)
                } else {
                    mas.append(c)
                    ups.append(c)
                    lows.append(c)
                }
            }
            
            for i in 0 ..< datas.count {
                let obj = datas[i]
                obj.boll = BOLL(up: ups[i], mid: mas[i], low: lows[i])
            }
        }

    }
    
    struct WR {
        var wr1: Double
        var wr2: Double
        
        static func calculate(datas: [KLine], params:[Int]) {
            guard params.count != 0 else { return }
            let days = params
            var result = [Int: [Double]]()
            var paramData = [Int: [KLine]]()
            
            for i in 0 ..< datas.count {
                let t = datas[i]
                let c = t.close
                
                for d in days {
                    var wrs = result[d] ?? []
                    var nwr = paramData[d] ?? []
                    nwr.append(t)
                    
                    var max = 0.0
                    var min = Double.infinity
                    
                    for mn in nwr {
                        max = .maximum(mn.high, max)
                        min = .minimum(mn.low, min)
                    }
                    
                    let nowWR = max > min ? 100.0 * (max - c) / (max - min) : 100
                    wrs.append(nowWR)
                    if nwr.count == d {
                        nwr.removeFirst()
                    }
                    
                    result[d] = wrs
                    paramData[d] = nwr
                }
            }
            
            for i in 0 ..< datas.count {
                let obj = datas[i]
                obj.wr = WR(wr1: result[6]![i], wr2: result[10]![i])
            }
        }
    }
    /**
     *  EMA(n) = 2 / (n + 1) * (C(n) - EMA(n - 1)) + EMA(n - 1)
     *  C(n):本期收盘价格
     */
    struct EMA {
        var ema1: Double
        var ema2: Double
        
        static func emaWithLastEma(lastEma: Double, close: Double, day: Int) -> Double {
            let a = 2.0 / Double(day - 1)
            return a * close + (1 - a) * lastEma
        }
        
        static func calculate(datas: [KLine], params:[Int]) {
            guard params.count != 0 else { return }
            
            let days = params
            var result = [Int: [Double]]()
            
            for i in 0 ..< datas.count {
                let t = datas[i]
                let c = t.close
                
                for d in days {
                    var emaArray = result[d] ?? []
                    if i == 0 {
                        emaArray.append(c)
                    } else {
                        emaArray.append(emaWithLastEma(lastEma: emaArray[i - 1], close: c, day: d))
                    }
                    result[d] = emaArray
                }
            }
            
            for i in 0 ..< datas.count {
                let obj = datas[i]
                obj.ema = EMA(ema1: result[7]![i], ema2: result[30]![i])
            }
        }
    }
}
