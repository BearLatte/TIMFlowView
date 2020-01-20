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
       fView.frame = view.bounds
       fView.contentInset = UIEdgeInsets(top: isIphoneX ? 88.0 : 64.0, left: 0, bottom: 0, right: 0)
       fView.dataSource = self
       fView.delegate   = self
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
    func numberOfCells(in flowView: TIMFlowView) -> Int { flowModels.count }
    
    func flowViewCell(in flowView: TIMFlowView, at index: Int) -> TIMFlowViewCell? {
        let cell = FlowDemoCell.cell(with: flowView)
        cell?.flowModel = flowModels[index]
        return cell
    }
}

extension DefaultDemoController: TIMFlowViewDelegate {
    func numberOfColmuns(in flowView: TIMFlowView) -> Int { 2 }
    
    func cellHeight(in flowView: TIMFlowView, at index: Int) -> CGFloat {
        let model = flowModels[index]
        return model.height * (flowView.cellWidth / model.width)
    }
    
    func didSelected(in flowView: TIMFlowView, at index: Int) {
        print("点击了第\(index)个cell")
    }
}
