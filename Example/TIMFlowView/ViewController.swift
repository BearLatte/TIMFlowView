//
//  ViewController.swift
//  TIMFlowView
//
//  Created by Tim on 01/16/2020.
//  Copyright (c) 2020 Tim. All rights reserved.
//

import UIKit
import TIMFlowView
import KakaJSON

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowView()
        setupData()
    }
    
    private func setupFlowView() {
        let fView = TIMFlowView()
        fView.frame = view.bounds
        fView.dataSource = self
        fView.delegate   = self
        fView.backgroundColor = UIColor.orange
        view.addSubview(fView)
        flowView = fView
    }
    
    private func setupData() {
        guard let plistPath = Bundle.main.path(forResource: "images.plist", ofType: nil),
            let models = NSArray(contentsOfFile: plistPath) as? [[String: Any]] else {
                print("未获取到模型文件")
                return
            }
        
        for model in models {
            flowModels.append(model.kj.model(FlowModel.self))
        }
        flowView.reloadData()
    }
    
    private weak var flowView: TIMFlowView!
    private lazy var flowModels: [FlowModel] = []
}

extension ViewController: TIMFlowViewDataSource {
    func numberOfCells(in flowView: TIMFlowView) -> Int { flowModels.count }
    
    func flowViewCell(in flowView: TIMFlowView, at index: Int) -> TIMFlowViewCell? {
        let cell = FlowDemoCell.cell(with: flowView)
        cell?.flowModel = flowModels[index]
        return cell
    }
}

extension ViewController: TIMFlowViewDelegate {
    func numberOfColmuns(in flowView: TIMFlowView) -> Int { 2 }
    
    func cellHeight(in flowView: TIMFlowView, at index: Int) -> CGFloat {
        let model = flowModels[index]
        return model.height * (flowView.cellWidth / model.width)
    }
    
    func didSelected(in flowView: TIMFlowView, at index: Int) {
        print("点击了第\(index)个cell")
    }
}

