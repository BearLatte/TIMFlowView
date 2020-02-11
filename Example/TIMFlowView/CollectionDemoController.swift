//
//  CollectionDemoController.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TIMFlowView

class CollectionDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "模仿 UIColletionView "
        view.backgroundColor = UIColor.orange
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
        fView.floatingHeaderEnable = true
        fView.backgroundColor = UIColor.orange
       
       // 添加 banner 视图
       let headerView = DemoHeaderView.headerView(with: kScreenWidth * 0.56) { (index) in
           print("点击了第\(index)个banner")
       }
       fView.flowHeaderView = headerView
        
        let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 120.0))
        footerLabel.text = "这是一个尾部视图的大title"
        footerLabel.backgroundColor = #colorLiteral(red: 0.7308493557, green: 0.141261917, blue: 1, alpha: 1)
        footerLabel.textColor = UIColor.white
        footerLabel.font = UIFont.systemFont(ofSize: 25.0)
        fView.flowFooterView = footerLabel
        
       
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


extension CollectionDemoController: TIMFlowViewDataSource {
    func numberOfColumns(in flowView: TIMFlowView, at section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 3
        }
    }
    
    func numberOfSections(in flowView: TIMFlowView) -> Int { 20 }
    func numberOfItems(in flowView: TIMFlowView, at section: Int) -> Int {
        switch section {
        case 0:
            return 9
        case 1:
            return flowModels.count
        default:
            return 9
        }
    }
    
    func flowViewItem(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> TIMFlowViewItem? {
        let section = indexPath.section
        switch section {
        case 0:
            let collectionItemID = "collectionItemID"
            var item: TIMFlowViewItem?
            guard let dequeueItem = flowView.dequeueReuseableItem(with: collectionItemID) else {
                item = TIMFlowViewItem(with: collectionItemID)
                item?.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                return item
            }
            item = dequeueItem
            return item
        case 1:
            let item = FlowDemoItem.item(with: flowView)
            item?.flowModel = flowModels[indexPath.item]
            return item
        default:
            let collectionItemID = "collectionItemID"
            var item: TIMFlowViewItem?
            guard let dequeueItem = flowView.dequeueReuseableItem(with: collectionItemID) else {
                item = TIMFlowViewItem(with: collectionItemID)
                item?.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                return item
            }
            item = dequeueItem
            return item
        }
    }
}

extension CollectionDemoController: TIMFlowViewDelegate {
    func itemHeight(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 80.0
        case 1:
            let model = flowModels[indexPath.item]
            return model.height * (flowView.itemWidhth(in: indexPath.section) / model.width)
        default:
            return 80.0
        }
    }
    
    func viewForSectionHeader(in flowView: TIMFlowView, at section: Int) -> TIMFlowHeaderFooterView? {
        let headerView = DemoSectionHeaderFooterView.headerFooterView(with: flowView)
        headerView?.sectionIndex = section
        return headerView
    }
    
    func viewForSectionFooter(in flowView: TIMFlowView, at section: Int) -> TIMFlowHeaderFooterView? {
        let footer = DemoSectionHeaderFooterView.headerFooterView(with: flowView)
        footer?.isHeader = false
        footer?.sectionIndex = section
        return footer
    }
    
    func didSelected(in flowView: TIMFlowView, at indexPath: TIMIndexPath) {
        print("点击了第\(indexPath.section)个分区的第\(indexPath.item)个item")
    }
}
