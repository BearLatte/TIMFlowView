//
//  TIMFlowView.swift
//  TIMFlowView
//
//  Created by Tim's Mac Book Pro on 2020/1/16.
//  Copyright © 2020 Tim. All rights reserved.
//  API 主视图

import UIKit

public class TIMFlowView: UIScrollView {
    // MARK: - Public Property
    /// 数据源协议
    weak public var dataSource: TIMFlowViewDataSource? = nil
    
    /// 代理协议
    public override var delegate: UIScrollViewDelegate? {
        didSet {
            flowViewDelegate = delegate as? TIMFlowViewDelegate
        }
    }
    
    
    // MARK: - Private Property
    /// 自定义一个代理对象，设置为私有
    /// 为了解决 UIScrollViewDelegate 和自定义 delegate 同名的冲突
    private weak var flowViewDelegate: TIMFlowViewDelegate? = nil
    
    /// 所有 cell 的位置信息
    private lazy var cellFrames: [CGRect] = []
    
    /// 当前正在显示的所有 cell
    private lazy var displayingCells: [Int: TIMFlowViewCell] = [:]
    
    /// 缓存池，存放已经滑出屏幕 frame 的 cell
    private lazy var reuseableCells: Set<TIMFlowViewCell> = []
}

// MARK: - Life Cycle
extension TIMFlowView {
    public override func willMove(toSuperview newSuperview: UIView?) {
        reloadData()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        // 获取 cell 的数量，根据数量遍历后拿到对应的 cell
        // 给 cell 设置 frame 添加到滚动视图上
        // 如果数据量非常大的情况下，此处会造成滑动时 CPU 占有率很高的性能问题
        // 待研究更理想的算法
        let numberOfCells = cellFrames.count
        for i in 0 ..< numberOfCells {
            let cellFrame = cellFrames[i]
            // 优先从字典中获取
            var cell = displayingCells[i]
            if isInScreen(cellFrame: cellFrame) {
                if cell == nil {
                    cell = dataSource?.flowViewCell(in: self, at: i)
                    cell?.frame = cellFrame
                    addSubview(cell!)
                    displayingCells[i] = cell
                }
            } else {
                if cell != nil {
                    cell!.removeFromSuperview()
                    displayingCells.removeValue(forKey: i)
                    reuseableCells.insert(cell!)
                }
            }
        }
    }
}

// MARK: - Public API
public extension TIMFlowView {
    /// 根据 self 的宽度计算 cell 的宽度
    var cellWidth: CGFloat {
        guard let column     = dataSource?.numberOfColmuns(in: self),
            let leftMargin   = flowViewDelegate?.margin(in: self, for: .left),
            let rightMargin  = flowViewDelegate?.margin(in: self, for: .right),
            let columnMargin = flowViewDelegate?.margin(in: self, for: .column) else {
                return 0
        }
        
        return (frame.width - leftMargin - rightMargin - CGFloat((column - 1)) * columnMargin) / CGFloat(column)
    }
    
    /// 刷新当前数据
    func reloadData() {
        // 将当前显示的所有 cell 从父视图中移除
        displayingCells.forEach { (key, value) in
            value.removeFromSuperview()
        }
        // 删除所有正在显示的cell
        displayingCells.removeAll()
        
        // 删除所有 frame 的缓存
        cellFrames.removeAll()
        
        // 清空缓存池
        reuseableCells.removeAll()
        
        // 获取列数
        let columns = numberOfColumns()
        
        // 获取 cell 的数量
        guard let cells = dataSource?.numberOfCells(in: self) else {
            return
        }
        
        // 获取所有的间距
        let topMargin    = margin(for: .top)
        let leftMargin   = margin(for: .left)
        let bottomMargin = margin(for: .bottom)
        let columnMargin = margin(for: .column)
        let rowMargin    = margin(for: .row)
        
        
        // 计算某一列的最大Y值
        var maxYOfColumns: [CGFloat] = []
        for _ in 0 ..< columns {
            maxYOfColumns.append(0.0)
        }
        
        for i in 0 ..< cells {
            let cellH: CGFloat = height(at: i)
            var cellColumn = 0
            var maxYOfCellColumn = maxYOfColumns[cellColumn]
            
            for j in 0 ..< columns {
                if maxYOfColumns[j] < maxYOfCellColumn {
                    cellColumn = j
                    maxYOfCellColumn = maxYOfColumns[j]
                }
                
            }
            
            // 计算 cell 的 x 值
            let cellX: CGFloat = leftMargin + CGFloat(cellColumn) * (columnMargin + cellWidth)
            var cellY: CGFloat = 0
            
            // 获取当前所有列中最大的Y值
            if maxYOfCellColumn == 0 {
                cellY = topMargin
            } else {
                cellY = maxYOfCellColumn + rowMargin
            }
            
            let frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellH)
            cellFrames.append(frame)
            maxYOfColumns[cellColumn] = frame.maxY
        }
        
        var contentH = maxYOfColumns[0]
        for i in 0 ..< maxYOfColumns.count {
            if maxYOfColumns[i] > contentH {
                contentH = maxYOfColumns[i]
            }
        }
        
        contentH += bottomMargin
        contentSize = CGSize(width: 0, height: contentH)
    }
    
    /// 从缓存池获取 cell
    /// - Parameter identifier: cell 的表示
    func dequeueReuseable(identifier: String) -> TIMFlowViewCell? {
        var reuseCell: TIMFlowViewCell?
        for (_, cell) in reuseableCells.enumerated() {
            if cell.reuseIdentifier == identifier {
                reuseCell = cell
                break
            }
        }
        
        if reuseCell != nil {
            reuseableCells.remove(reuseCell!)
        }
        
        return reuseCell
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flowViewDelegate == nil {
            return
        }
        
        guard let touch = (touches as NSSet).anyObject() as? UITouch else {
            return
        }
        
        let point = touch.location(in: self)
        var selectedIndex: Int? = nil
        for (key, value) in displayingCells {
            if value.frame.contains(point) {
                selectedIndex = key
                break
            }
        }
        
        if selectedIndex != nil {
            flowViewDelegate?.didSelected(in: self, at: selectedIndex!)
        }
    }
}

// MARK: - Private API
extension TIMFlowView {
    private func isInScreen(cellFrame: CGRect) -> Bool {
        (cellFrame.maxY > contentOffset.y) && (cellFrame.minY < (contentOffset.y + bounds.height))
    }
    
    private func margin(for type: TIMFlowViewCellMarginType) -> CGFloat {
        if let margin = flowViewDelegate?.margin(in: self, for: type) {
            return margin
        }
        
        return DEFAULT_CELL_MARGIN
    }
    
    private func numberOfColumns() -> Int {
        if let columns = dataSource?.numberOfColmuns(in: self) {
            return columns
        }
        
        return DEFAULT_COLUMN_COUNT
    }
    
    private func height(at index: Int) -> CGFloat {
        if let height = flowViewDelegate?.cellHeight(in: self, at: index) {
            return height
        }
        
        return DEFAULT_CELL_HEIGHT
    }
}
