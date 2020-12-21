//
//  KLineView.swift
//  YourMoney
//
//  Created by Yan on 2020/12/2.
//

import UIKit
import SnapKit

class KLineView: UIView {
    var linePainter: Painter.Type!
    var indicator1Painter: Painter.Type?
    var indicator2Painter: Painter.Type
    var painterViewLeftConstraint: Constraint?
    
    var rootModel = KLineRoot()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var painterView: UIView = {
        let painterView = UIView()
        return painterView
    }()
    
    lazy var rightView: UIView = {
        let rightView = UIView()
        return rightView
    }()
    /// 长按后显示的View
    lazy var verticalView: UIView = {
        let verticalView = UIView()
        verticalView.clipsToBounds = true
        verticalView.backgroundColor = UIColor.longPressLineColor.withAlphaComponent(0.5)
        verticalView.isHidden = true
        return verticalView
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var middleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var oldExactOffset: CGFloat = 0 // 旧的scrollview准确位移
    var pinchCenterX: CGFloat = 0
    var pinchIndex = 0
    var needDrawStartIndex = 0 // 需要绘制Index开始值
    var oldContentOffsetX: CGFloat = 0 // 旧的contentoffset值
    var oldScale: CGFloat = 1 // 旧的缩放值，捏合
    var mainViewRatio: CGFloat // 第一个View的高所占比例
    var volumeViewRatio: CGFloat // 第二个View(成交量)的高所占比例
    var oldPositionX: CGFloat = 0
    
    override init(frame: CGRect) {
        
        mainViewRatio = KLineGlobalVariable.mainViewRadio
        volumeViewRatio = KLineGlobalVariable.volumeViewRadio
        indicator1Painter = MAPainter.self
        indicator2Painter = MACDPainter.self
        
        super.init(frame: frame)
        
        initUI()
        addGestures()
    }
    
    private func addGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(event_pichMethod(pinch:)))
        scrollView.addGestureRecognizer(pinchGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(event_longPressMethod(longPress:)))
        scrollView.addGestureRecognizer(longPressGesture)
    }
    
    private func initUI() {
        addSubview(scrollView)
        addSubview(rightView)
        addSubview(topLabel)
        addSubview(middleLabel)
        addSubview(bottomLabel)

        scrollView.addSubview(painterView)
        scrollView.addSubview(verticalView)
        
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.right.equalTo(-KLineGlobalVariable.priceViewWidth)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        painterView.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(scrollView)
            painterViewLeftConstraint = make.left.equalTo(scrollView).constraint
        }
        
        rightView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.width.equalTo(KLineGlobalVariable.priceViewWidth)
        }
        
        verticalView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.width.equalTo(KLineGlobalVariable.longPressVerticalViewWidth)
            make.height.equalTo(scrollView)
            make.centerX.equalTo(0)
        }
        
        topLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(5)
            make.height.equalTo(10)
        }
        
        middleLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(snp.bottom).multipliedBy(mainViewRatio)
            make.height.equalTo(20)
        }
        
        bottomLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(self)
            make.top.equalTo(snp.bottom).multipliedBy(mainViewRatio + volumeViewRatio)
            make.height.equalTo(20)
        }
    }
    
    // functions
    @objc private func event_pichMethod(pinch: UIPinchGestureRecognizer) {
        switch pinch.state {
        case .began:
            scrollView.isScrollEnabled = false
            let p1 = pinch.location(ofTouch: 0, in: painterView)
            let p2 = pinch.location(ofTouch: 1, in: painterView)
            pinchCenterX = (p1.x + p2.x) / 2
            pinchIndex = Int(abs(floor(pinchCenterX + scrollView.contentOffset.x) / (KLineGlobalVariable.lineWidth + KLineGlobalVariable.lineGap)))
        case .ended:
            scrollView.isScrollEnabled = true
        default:
            break
        }
        
        let difValue = pinch.scale - oldScale
        if abs(difValue) > KLineGlobalVariable.scaleBound {
            let oldKLineWidth = KLineGlobalVariable.lineWidth
            let newKLineWidth = oldKLineWidth * (difValue > 0 ? (1 + KLineGlobalVariable.scaleFactor) : (1 - KLineGlobalVariable.scaleFactor))
            if oldKLineWidth == KLineGlobalVariable.lineMinWidth && difValue <= 0 {
                return
            }
            
            // 右侧已经没有更多数据时，从右侧开始缩放
            if (scrollView.frame.width - pinchCenterX) / (newKLineWidth + KLineGlobalVariable.lineGap) > CGFloat(rootModel.models.count - pinchIndex) {
                pinchIndex = rootModel.models.count - 1
                pinchCenterX = scrollView.frame.width
            }
            
            // 左侧已经没有更多数据时，从左侧开始缩放
            if CGFloat(pinchIndex) * (newKLineWidth + KLineGlobalVariable.lineGap) < pinchCenterX {
                pinchIndex = 0
                pinchCenterX = 0
            }
            
            if scrollView.frame.width / (newKLineWidth + KLineGlobalVariable.lineGap) > CGFloat(rootModel.models.count) {
                pinchIndex = 0
                pinchCenterX = 0
            }
            
            KLineGlobalVariable.setKLine(width: newKLineWidth)
            oldScale = pinch.scale
            let idx = pinchIndex - Int(floor(pinchCenterX / (KLineGlobalVariable.lineGap + KLineGlobalVariable.lineWidth)))
            let offset = CGFloat(idx) * (KLineGlobalVariable.lineGap + KLineGlobalVariable.lineWidth)
            rootModel.calculateNeedDrawTimeModel()
            updateScrollViewContentSize()
            scrollView.contentOffset = CGPoint(x: offset, y: 0)
            if scrollView.contentSize.width < scrollView.bounds.size.width {
                scrollViewDidScroll(scrollView)
            }
        }
    }
    
    @objc private func event_longPressMethod(longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .changed, .began:
            let location = longPress.location(in: scrollView)
            if abs(oldPositionX - location.x) < (KLineGlobalVariable.lineWidth + KLineGlobalVariable.lineGap) / 2 {
                return
            }
            
            scrollView.isScrollEnabled = false
            oldPositionX = location.x
            var idx = Int(abs(floor(location.x / (KLineGlobalVariable.lineWidth + KLineGlobalVariable.lineGap))))
            idx = min(idx, rootModel.models.count - 1)
            updateLabelText(m: rootModel.models[idx])
            
            let offset = CGFloat(idx) * (KLineGlobalVariable.lineWidth + KLineGlobalVariable.lineGap) + KLineGlobalVariable.lineWidth / 2 - KLineGlobalVariable.lineGap / 2
            
            verticalView.snp.updateConstraints { (make) in
                make.centerX.equalTo(offset)
                make.width.equalTo(KLineGlobalVariable.lineWidth)
            }
            verticalView.layoutIfNeeded()
            verticalView.isHidden = false
        case .ended:
            verticalView.isHidden = true
            oldPositionX = 0
            scrollView.isScrollEnabled = true
            if let model = rootModel.models.last {
                updateLabelText(m: model)
            }
        default:
            break
        }
    }
    
    private func calculateNeedDrawModels() {
        let lineGap = KLineGlobalVariable.lineGap
        let lineWidth = KLineGlobalVariable.lineWidth
        
        let needDrawKLineCount = Int(ceil(scrollView.frame.width / (lineGap + lineWidth)) + 1)
        let scrollViewOffsetX = scrollView.contentOffset.x < 0 ? 0 : scrollView.contentOffset.x;
        let leftArrCount = floor(scrollViewOffsetX / (lineGap + lineWidth))
        needDrawStartIndex = Int(leftArrCount)
        
        var array = [KLine]()
        if needDrawStartIndex < rootModel.models.count {
            if needDrawStartIndex + needDrawKLineCount < rootModel.models.count {
                array = Array(rootModel.models[needDrawStartIndex ..< needDrawStartIndex + needDrawKLineCount])
            } else {
                array = Array(rootModel.models[needDrawStartIndex ..< rootModel.models.count])
            }
        }
        draw(with: array)
    }
    
    private func draw(with models: [KLine]) {
        guard !models.isEmpty else { return }
        var minMax = KLineMinMax(min: 9999999999999, max: 0)
        minMax.combine(m: linePainter.getMinMaxValue(models: models))
        
        if let indicator1Painter = indicator1Painter {
            minMax.combine(m: indicator1Painter.getMinMaxValue(models: models))
        }
        
        painterView.layer.sublayers = nil
        rightView.layer.sublayers = nil
        
        let offsetX = CGFloat(models.first!.index) * (KLineGlobalVariable.lineWidth + KLineGlobalVariable.lineGap) - scrollView.contentOffset.x
        let mainArea = CGRect(x: offsetX, y: 20, width: painterView.bounds.width, height: painterView.bounds.height * mainViewRatio - 20)
        let secondArea = CGRect(x: offsetX, y: mainArea.maxY + 20, width: mainArea.width, height: painterView.bounds.height * volumeViewRatio - 20)
        let thirdArea = CGRect(x: offsetX, y: secondArea.maxY + 20, width: mainArea.width, height: painterView.bounds.height * (1 - mainViewRatio - volumeViewRatio) - 40)
        // 右侧价格轴
        VerticalTextPainter.draw(to: rightView.layer, area: CGRect(x: 0, y: 20, width: KLineGlobalVariable.priceViewWidth, height: mainArea.height), minMaxModel: minMax)
        // 右侧成交量轴
        VerticalTextPainter.draw(to: rightView.layer, area: CGRect(x: 0, y: mainArea.maxY + 20, width: KLineGlobalVariable.priceViewWidth, height: secondArea.height), minMaxModel: VolPainter.getMinMaxValue(models: models))
//        // 右侧副图
        VerticalTextPainter.draw(to: rightView.layer, area: CGRect(x: 0, y: thirdArea.origin.y, width: KLineGlobalVariable.priceViewWidth, height: thirdArea.height), minMaxModel: MACDPainter.getMinMaxValue(models: models))
        // 主图
        linePainter.draw(to: painterView.layer, area: mainArea, models: models, minMax: minMax)
        
        if let indicator1Painter = indicator1Painter {
            indicator1Painter.draw(to: painterView.layer, area: mainArea, models: models, minMax: minMax)
        }
        // 成交量图
        VolPainter.draw(to: painterView.layer, area: secondArea, models: models, minMax: VolPainter.getMinMaxValue(models: models))
        // 副图指标
        indicator2Painter.draw(to: painterView.layer, area: thirdArea, models: models, minMax: indicator2Painter.getMinMaxValue(models: models))
        // 时间轴
        TimePainter.draw(to: painterView.layer, area: CGRect(x: offsetX, y: thirdArea.maxY, width: mainArea.width + 20, height: 20), models: models, minMax: minMax)

        updateLabelText(m: models.last!)
    }
    
    private func updateLabelText(m: KLine) {
        if let indicator1Painter = indicator1Painter {
            topLabel.attributedText = indicator1Painter.getText(model: m)
        } else {
            topLabel.attributedText = m.v_price
        }
        
        middleLabel.attributedText = m.v_volume
        bottomLabel.attributedText = indicator2Painter.getText(model: m)
    }
    
    private func  updateScrollViewContentSize() {
        let  contentSizeW = CGFloat(rootModel.models.count) * KLineGlobalVariable.lineWidth + (CGFloat(rootModel.models.count) - 1) * KLineGlobalVariable.lineGap
        scrollView.contentSize = CGSize(width: contentSizeW, height: scrollView.contentSize.height)
    }
    
    func reDraw() {
        DispatchQueue.main.async { [self] in
            let kLineViewWidth = CGFloat(rootModel.models.count) * KLineGlobalVariable.lineWidth + (CGFloat(rootModel.models.count) + 1) * KLineGlobalVariable.lineGap + 10
            updateScrollViewContentSize()
            let offset = kLineViewWidth - scrollView.frame.width
            scrollView.contentOffset = CGPoint(x: .maximum(offset, 0), y: 0)
            if offset == oldContentOffsetX {
                calculateNeedDrawModels()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KLineView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let painterViewLeftConstraint = painterViewLeftConstraint else { return }
        if scrollView.contentOffset.x < 0 {
            painterViewLeftConstraint.update(offset: 0)
        } else {
            painterViewLeftConstraint.update(offset: scrollView.contentOffset.x)
        }
        oldContentOffsetX = scrollView.contentOffset.x
        calculateNeedDrawModels()
    }
}
