//
//  ViewController.swift
//  KLineDemo
//
//  Created by Yan on 2020/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    var needPortrait: Bool = false
    
    lazy var kLineView: KLineView = {
        let kLineView = KLineView()
        return kLineView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .white)
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.backgroundColor
        view.addSubview(kLineView)
        view.addSubview(indicatorView)
        kLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(80)
            make.height.equalTo(400)
        }
        
        indicatorView.snp.makeConstraints { (make) in
            make.edges.equalTo(kLineView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stockDatas(with: 5)
    }
    
    private func stockDatas(with index: Int) {
        let dict = [1: "1m", 2: "1m", 3: "5m", 4: "15m", 5: "30m", 6: "1h", 7: "1d", 8: "1w"]
        indicatorView.startAnimating()
        
        let urlString = "https://h5-market.niuyan.com/web/v1/ticker/kline?exchange_id=zb&base_symbol=VSYS&quote_symbol=QC&lan=zh-cn&size=500&interval=\(dict[index]!)"
        
        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            defer {
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                }
            }
            
            guard error == nil else { return }
            guard let data = data else { return }
            var dict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            dict = dict["data"] as! [String: Any]
            let dic = dict["data"] as! [[Double]]
            let model = KLineRoot.newRoot(arr: dic)
            self.reloadWithData(rootModel: model)
        }
        task.resume()
    }
    
    func reloadWithData(rootModel: KLineRoot?) {
        guard let rootModel = rootModel else { return }
        kLineView.rootModel = rootModel
        kLineView.linePainter = CandlePainter.self
        kLineView.reDraw()
    }
}
