//
//  ViewController.swift
//  TIMFlowView
//
//  Created by Tim on 01/16/2020.
//  Copyright (c) 2020 Tim. All rights reserved.
//

import UIKit
import TIMFlowView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowView()
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
    
    private weak var flowView: TIMFlowView!
}

extension ViewController: TIMFlowViewDataSource {
    func numberOfCells(in flowView: TIMFlowView) -> Int { 10000 }
    
    func flowViewCell(in flowView: TIMFlowView, at index: Int) -> TIMFlowViewCell? {
        let cellID = "FlowCell"
        guard let cell = flowView.dequeueReuseable(identifier: cellID) else {
            let flowCell = TIMFlowViewCell(with: cellID)
            flowCell.backgroundColor = UIColor.yellow
            return flowCell
        }
        cell.backgroundColor = UIColor.yellow
        return cell;
    }
}

extension ViewController: TIMFlowViewDelegate {
    func numberOfColmuns(in flowView: TIMFlowView) -> Int {
        4
    }
    func cellHeight(in flowView: TIMFlowView, at index: Int) -> CGFloat {
        200
    }
    func didSelected(in flowView: TIMFlowView, at index: Int) {
        print("点击了第\(index)个cell")
    }
}

