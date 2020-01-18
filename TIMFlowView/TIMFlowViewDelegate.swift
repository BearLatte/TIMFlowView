//
//  TIMFlowViewDelegate.swift
//  TIMFlowView
//
//  Created by Tim's Mac Book Pro on 2020/1/16.
//  Copyright © 2020 Tim. All rights reserved.
//

public protocol TIMFlowViewDelegate: UIScrollViewDelegate {
    /// 返回 cell 的高度
    /// - Parameters:
    ///   - flowView: 提供瀑布流视图给外部使用
    ///   - index:    cell 的索引
    func cellHeight(in flowView: TIMFlowView, at index: Int) -> CGFloat
    
    /// 返回 cell 的间距，可根据类型分别返回，默认为 8 个点
    /// - Parameters:
    ///   - flowView:   提供瀑布流视图给外部使用
    ///   - marginType: 间距的类型，分别有：上，左，下，右，每一行，每一列
    func margin(in flowView: TIMFlowView, for marginType: TIMFlowViewCellMarginType) -> CGFloat
    
    /// 点击 cell 时的回调
    /// - Parameters:
    ///   - flowView: 提供瀑布流视图给外部使用
    ///   - index:    cell 的索引
    func didSelected(in flowView: TIMFlowView, at index: Int)
}

public extension TIMFlowViewDelegate {
    func cellHeight(in flowView: TIMFlowView, at index: Int) -> CGFloat { DEFAULT_CELL_HEIGHT }
    func margin(in flowView: TIMFlowView, for marginType: TIMFlowViewCellMarginType) -> CGFloat { DEFAULT_CELL_MARGIN }
    func didSelected(in flowView: TIMFlowView, at index: Int) { }
}
