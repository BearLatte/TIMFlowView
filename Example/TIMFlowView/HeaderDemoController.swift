//
//  HeaderDemoController.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import KakaJSON
import TIMFlowView

class HeaderDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "带有 Header 的瀑布流"
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
        
        // 添加 banner 视图
        let headerView = DemoHeaderView.headerView(with: kScreenWidth * 0.56) { (index) in
            print("点击了第\(index)个banner")
        }
        
        
        let imgs = [
            "https://i.ibb.co/qBmnXTS/allergy.png",
            "https://i.ibb.co/9wxjxRK/little-door-god.png",
            "https://i.ibb.co/WK8yW48/Microfilm.png",
            "https://i.ibb.co/sH53rr0/nezha.png",
            "https://i.ibb.co/BGy9jqN/recruitment.png",
            "https://i.ibb.co/2NTHX9T/stronger-brain.png",
            "https://i.ibb.co/ts4dhWg/years-as-flowers.png"
        ]
        
        let titles = [
            "如果你对无聊过敏，请来靴小姐挂号",
            "追光动画 --- 小门神",
            "微电影演员招募集结号",
            "哪吒 --- 不认命便是我的命",
            "我玩我擅长 会乐器可以称霸",
            "最强大脑新一季",
            "梁晓雪 首张全创作大碟"
        ]
        
        
        
        headerView.images = imgs
        headerView.titles = titles
        fView.headerView = headerView
        
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

extension HeaderDemoController: TIMFlowViewDataSource {
    func numberOfCells(in flowView: TIMFlowView) -> Int { flowModels.count }
    
    func flowViewCell(in flowView: TIMFlowView, at index: Int) -> TIMFlowViewCell? {
        let cell = FlowDemoCell.cell(with: flowView)
        cell?.flowModel = flowModels[index]
        return cell
    }
}

extension HeaderDemoController: TIMFlowViewDelegate {
    func numberOfColmuns(in flowView: TIMFlowView) -> Int { 2 }
    
    func cellHeight(in flowView: TIMFlowView, at index: Int) -> CGFloat {
        let model = flowModels[index]
        return model.height * (flowView.cellWidth / model.width)
    }
    
    func didSelected(in flowView: TIMFlowView, at index: Int) {
        print("点击了第\(index)个cell")
    }
}
