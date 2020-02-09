//
//  DefaultDemoController.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TIMFlowView
import KakaJSON

class DefaultDemoController: UIViewController {

    override func viewDidLoad() {
           super.viewDidLoad()
           title = "最普通的瀑布流"
           setupFlowView()
           setupData()
       }
    
    private func setupFlowView() {
       let fView = TIMFlowView()
       let flowVY: CGFloat = isIphoneX ? 88.0 : 64.0
       let height = kScreenHeight - flowVY
       fView.frame = CGRect(x: 0, y: flowVY, width: view.bounds.width, height: height)
       fView.flowDataSource = self
       fView.flowDelegate   = self
       fView.backgroundColor = UIColor.orange
       view.addSubview(fView)
       flowView = fView
    }
       
   private func setupData() {
        DispatchQueue.global().async {
            guard let plistPath = Bundle.main.path(forResource: "images.plist", ofType: nil),
                let models = NSArray(contentsOfFile: plistPath) as? [[String: Any]] else {
                    print("未获取到模型文件")
                    return
                }
            
            for model in models {
                self.flowModels.append(model.kj.model(FlowModel.self))
            }
            
            DispatchQueue.main.async {
                self.flowView.reloadData()
            }
        }
   }
   
   private weak var flowView: TIMFlowView!
   private lazy var flowModels: [FlowModel] = []

}

extension DefaultDemoController: TIMFlowViewDataSource {
    func numberOfColumns(in flowView: TIMFlowView, at section: Int) -> Int {
        2
    }
    func numberOfItems(in flowView: TIMFlowView, at section: Int) -> Int {
        flowModels.count
    }
    
    func flowViewItem(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> TIMFlowViewItem? {
        let item = FlowDemoItem.item(with: flowView)
        item?.flowModel = flowModels[indexPath.item]
        return item
    }
}

extension DefaultDemoController: TIMFlowViewDelegate {
    func itemHeight(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> CGFloat {
        let model = flowModels[indexPath.item]
        return model.height * (flowView.itemWidhth(in: indexPath.section) / model.width)
    }
    
    func didSelected(in flowView: TIMFlowView, at indexPath: TIMIndexPath) {
        print("点击了第\(indexPath.section)个分区的第\(indexPath.item)个item")
    }
}
