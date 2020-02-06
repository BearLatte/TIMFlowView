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
    func itemHeight(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> CGFloat
    
    /// 返回 cell 的间距，可根据类型分别返回，默认为 8 个点
    /// - Parameters:
    ///   - flowView:   提供瀑布流视图给外部使用
    ///   - marginType: 间距的类型，分别有：上，左，下，右，每一行，每一列
    func margin(in flowView: TIMFlowView, at section: Int, for marginType: TIMFlowViewCellMarginType) -> CGFloat
    
    /// 点击 cell 时的回调
    /// - Parameters:
    ///   - flowView: 提供瀑布流视图给外部使用
    ///   - index:    cell 的索引
    func didSelected(in flowView: TIMFlowView, at indexPath: TIMIndexPath)
    
    /// 分区头视图
    /// - Parameters:
    ///   - flowView: 提供瀑布流视图给外部使用
    ///   - sectionIndex: 分区索引
    func viewForSectionHeader<V: TIMFlowHeaderFooterView>(in flowView: TIMFlowView, at section: Int) -> V?
    
    /// 分区尾视图
    /// - Parameters:
    ///   - flowView: 提供瀑布流视图给外部使用
    ///   - sectionIndex: 分区索引
    func viewForSectionFooter<V: TIMFlowHeaderFooterView>(in flowView: TIMFlowView, at section: Int) -> V?
}

public extension TIMFlowViewDelegate {
    func itemHeight(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> CGFloat { DEFAULT_CELL_HEIGHT }
    func margin(in flowView: TIMFlowView, at section: Int, for marginType: TIMFlowViewCellMarginType) -> CGFloat { DEFAULT_CELL_MARGIN }
    func didSelected(in flowView: TIMFlowView, at indexPath: TIMIndexPath)  { }
    func viewForSectionHeader<V: TIMFlowHeaderFooterView>(in flowView: TIMFlowView, at section: Int) -> V? { nil }
    func viewForSectionFooter<V: TIMFlowHeaderFooterView>(in flowView: TIMFlowView, at section: Int) -> V? { nil }
}
