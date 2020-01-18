//
//  TIMFlowViewDataSource.swift
//  TIMFlowView
//
//  Created by Tim's Mac Book Pro on 2020/1/16.
//  Copyright © 2020 Tim. All rights reserved.
//

import Foundation

public protocol TIMFlowViewDataSource: NSObjectProtocol {
    /// 返回 cell 的数量
    /// - Parameter flowView: 提供视图给外面设置
    func numberOfCells(in flowView: TIMFlowView) -> Int
    
    /// 返回列数，默认为两列
    /// - Parameter flowView: 提供视图给外面设置
    func numberOfColmuns(in flowView: TIMFlowView) -> Int
    
    /// 返回 index 对应索引的 cell
    /// - Parameters:
    ///   - flowView: 提供视图给外面设置
    ///   - index:    提供索引给外面使用
    func flowViewCell(in flowView: TIMFlowView, at index: Int) -> TIMFlowViewCell?
}

public extension TIMFlowViewDataSource {
    func numberOfColmuns(in flowView: TIMFlowView) -> Int { DEFAULT_COLUMN_COUNT }
}
