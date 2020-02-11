//
//  TIMFlowView.swift
//  TIMFlowView
//
//  Created by Tim's Mac Book Pro on 2020/1/16.
//  Copyright © 2020 Tim. All rights reserved.
//  API 主视图

import UIKit

open class TIMFlowView: UIScrollView {
    // MARK: - Public Property
    /// 瀑布流数据源协议
    open weak var flowDataSource: TIMFlowViewDataSource? = nil
    
    /// 瀑布流代理协议
    open weak var flowDelegate: TIMFlowViewDelegate?
    
    /// 是否让分区头视图悬停
    public var floatingHeaderEnable: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 头视图
    /// 默认与 flowView 同宽，高度根据传进来高度自动计算
    public var flowHeaderView: TIMFlowHeaderView? {
        willSet {
            guard let header = newValue else {
                return
            }
            header.layoutIfNeeded()
            var headerFrame = header.frame
            headerFrame = CGRect(x: 0, y: 0, width: bounds.width, height: headerFrame.height)
            header.frame = headerFrame
            insertSubview(header, at: 0)
            floatingBeginY = header.frame.maxY
        }
    }
    
    
    // MARK: - Private Property
    
    /// 所有 cell 的位置信息, key: section, value: section 对应的 cell 的frame
    private lazy var itemFrames: [Int: [CGRect]] = [:]
    
    /// 当前正在显示的所有 cell
    private lazy var displayingItems: [TIMIndexPath: TIMFlowViewItem] = [:]
    
    /// cell 缓存池，存放已经滑出屏幕 frame 的 cell, key: section 索引， value: section对应的缓存池
    private lazy var reuseableItems: [Int: Set<TIMFlowViewItem>] = [:]
    
    /// 所有分区头视图的位置信息
    private lazy var sectionHeaderFrames: [CGRect?] = []
    
    /// 当前显示的分区头视图
    private lazy var displayingSectionHeader: [Int: TIMFlowHeaderFooterView] = [:]
    
    /// 分区头缓存池, 存放已经划出屏幕 frame 的 分区头视图
    private lazy var reuseableSectionHeader: Set<TIMFlowHeaderFooterView> = []
    
    /// 所有分区尾视图的位置信息
    private lazy var sectionFooterFrames: [CGRect?] = []
    
    /// 当前显示的分区尾视图
    private lazy var displayingSectionFooter: [Int: TIMFlowHeaderFooterView] = [:]
    
    /// 分区尾缓存池，存放已经划出屏幕 frame 的 分区尾视图
    private lazy var reuseableSectionFooter: Set<TIMFlowHeaderFooterView> = []

    /// 需要悬停的header
    private var needFloatingHeader: [Int: TIMFlowHeaderFooterView] = [:]
    
    /// 记录当前偏移量
    private var offsetY: CGFloat = 0
    
    /// 记录初始 Y 值，也就是说在哪个位置开始悬停
    private var floatingBeginY: CGFloat = 0
    
    /// 记录当前悬停的视图索引
    private var currentFloatingIndex = 0

    /// 记录当前悬停的视图
    private var currentFloatingHeaderView: TIMFlowHeaderFooterView?
    
    /// 记录临界点
    private var criticalY: CGFloat = 0
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
        
        // 获取分区数
        let numberOfSection: Int! = flowDataSource?.numberOfSections(in: self)
        
        for sectionIndex in 0 ..< numberOfSection {
            // 布局分区头视图
            if floatingHeaderEnable {
                guard let headerView = needFloatingHeader[sectionIndex] else {
                    return
                }
                
                if isInScreen(aFrame: headerView.frame) {
                    addSubview(headerView)
                }
                
            } else {
                if let sectionHeaderFrame = sectionHeaderFrames[sectionIndex] {
                    var sectionHeader = displayingSectionHeader[sectionIndex]
                    if isInScreen(aFrame: sectionHeaderFrame) {
                        if sectionHeader == nil {
                            sectionHeader = flowDelegate?.viewForSectionHeader(in: self, at: sectionIndex)
                            sectionHeader?.frame = sectionHeaderFrame
                            addSubview(sectionHeader!)
                            displayingSectionHeader[sectionIndex] = sectionHeader
                        }
                    } else {
                        if sectionHeader != nil {
                            sectionHeader?.removeFromSuperview()
                            displayingSectionHeader.removeValue(forKey: sectionIndex)
                            reuseableSectionHeader.insert(sectionHeader!)
                        }
                    }
                }
            }
            
            // 布局每个 item
            guard let currentSectionItemFrames = itemFrames[sectionIndex] else {
                return
            }
            
            // 获取 item 数量
            let numberOfItems = currentSectionItemFrames.count
            for i in 0 ..< numberOfItems {
                let itemFrame = currentSectionItemFrames[i]

                // 从字典中取出item
                let indexPath = TIMIndexPath(sectionIndex, i)
                var item = displayingItems[indexPath]
                
                if isInScreen(aFrame: itemFrame) {
                    if item == nil {
                        item = flowDataSource?.flowViewItem(in: self, at: indexPath)
                        item?.frame = itemFrame
                        addSubview(item!)
                        displayingItems[indexPath] = item
                    }
                } else {
                    if item != nil {
                        item?.removeFromSuperview()
                        displayingItems.removeValue(forKey: indexPath)
                        reuseableItems[sectionIndex]?.insert(item!)
                    }
                }
            }
            
            // 布局分区尾部视图
            if let sectionFooterFrame = sectionFooterFrames[sectionIndex] {
                var sectionFooter = displayingSectionFooter[sectionIndex]
                if isInScreen(aFrame: sectionFooterFrame) {
                    if sectionFooter == nil {
                        sectionFooter = flowDelegate?.viewForSectionFooter(in: self, at: sectionIndex)
                        sectionFooter?.frame = sectionFooterFrame
                        addSubview(sectionFooter!)
                        displayingSectionFooter[sectionIndex] = sectionFooter
                    }
                } else {
                    if sectionFooter != nil {
                        sectionFooter?.removeFromSuperview()
                        displayingSectionFooter.removeValue(forKey: sectionIndex)
                        reuseableSectionFooter.insert(sectionFooter!)
                    }
                }
            }
        }
    }
}

// MARK: - Public API
public extension TIMFlowView {
    /// 根据 self 的宽度计算 cell 的宽度
    func itemWidhth(in section: Int) -> CGFloat {
        guard let numberOfSections = flowDataSource?.numberOfSections(in: self) else {
            return 0
        }
        
        // 越界异常抛出
        if section >= numberOfSections {
            fatalError("索引越界，当前操作的分区不能大于总分区数量")
        }
        
        // 获取列数
        guard let numberOfColumns = flowDataSource?.numberOfColumns(in: self, at: section),
            let leftMargin = flowDelegate?.margin(in: self, at: section, for: .left),
            let rightMrgin = flowDelegate?.margin(in: self, at: section, for: .right),
            let columnMargin = flowDelegate?.margin(in: self, at: section, for: .column) else {
            return 0
        }
        
        return (frame.width - leftMargin - rightMrgin - CGFloat(numberOfColumns - 1) * columnMargin) / CGFloat(numberOfColumns)
    }
    
    /// 刷新当前数据
    func reloadData() {
        // 删除所有的分区头视图
        displayingSectionHeader.forEach { (_, value) in
            value.removeFromSuperview()
        }
        
        displayingSectionHeader.removeAll()
        sectionHeaderFrames.removeAll()
        reuseableSectionHeader.removeAll()
        
        // 将当前显示的所有 cell 从父视图移除
        displayingItems.forEach { (_, value) in
            value.removeFromSuperview()
        }
        
        // 删除所有正在显示的cell
        displayingItems.removeAll()
        

        // 删除所有 frame 的缓存
        itemFrames.removeAll()

        // 清空缓存池
        reuseableItems.removeAll()
        
        // 删除分区尾视图
        displayingSectionFooter.forEach { (_, value) in
            value.removeFromSuperview()
        }
        displayingSectionFooter.removeAll()
        sectionFooterFrames.removeAll()
        reuseableSectionFooter.removeAll()
        
        // 删除保留的悬停数据
        needFloatingHeader.forEach { (_, value) in
            value.removeFromSuperview()
        }
        needFloatingHeader.removeAll()
        
        // 获取分区数
        guard let numberOfSections: Int = flowDataSource?.numberOfSections(in: self) else {
            return
        }
            
        for _ in 0 ..< numberOfSections {
            sectionHeaderFrames.append(nil)
            sectionFooterFrames.append(nil)
        }
        
        // 保留一个记录最大 Y 值的对象
        var maxY = flowHeaderView == nil ? 0.0 : flowHeaderView?.frame.height ??  0.0
        
            // 根据分区计算每个 header、footer、cell 的 frame
            for sectionIndex in 0 ..< numberOfSections {
                // 保存 item 的宽度
                let itemW = self.itemWidhth(in: sectionIndex)
                
                // 获取列数
                let columns = self.numberOfColumns(section: sectionIndex)
                
                // 获取当前分区的 cell 的数量
                let numberOfItems = (self.flowDataSource?.numberOfItems(in: self, at: sectionIndex))!
                
                // 获取当前分区的间距设置
                let topMargin    = self.margin(at: sectionIndex, for: .top)
                let leftMargin   = self.margin(at: sectionIndex, for: .left)
                let bottomMargin = self.margin(at: sectionIndex, for: .bottom)
                let columnMargin = self.margin(at: sectionIndex, for: .column)
                let rowMargin    = self.margin(at: sectionIndex, for: .row)
                
                // 获取当前分区的头视图
                if let sectionHeaederView = self.flowDelegate?.viewForSectionHeader(in: self, at: sectionIndex) {
                    let sectionFrame = CGRect(x: 0, y: maxY, width: self.bounds.width, height: sectionHeaederView.frame.height)
                    self.sectionHeaderFrames[sectionIndex] = sectionFrame
                    if floatingHeaderEnable == true {
                        sectionHeaederView.frame = sectionFrame
                        needFloatingHeader[sectionIndex] = sectionHeaederView
                    }
                    maxY = sectionFrame.maxY
                }
                
                // 计算某一列的最大Y值
                var maxYOfColumns: [CGFloat] = []
                for _ in 0 ..< columns {
                    maxYOfColumns.append(maxY)
                }
                
                // 计算每个 item 的 frame
                var itemFrames: [CGRect] = []
                for itemIndex in 0 ..< numberOfItems {
                    let itemH = self.height(at: TIMIndexPath(sectionIndex, itemIndex))       // 高度
                    var itemColumn = 0                                                  // 当前列索引
                    var maxYOfItemColumn = maxYOfColumns[itemColumn]                    // 取出第一列的Y值
                    
                    for i in 0 ..< columns {
                        if maxYOfColumns[i] < maxYOfItemColumn {
                            itemColumn = i
                            maxYOfItemColumn = maxYOfColumns[i]
                        }
                    }
                    
                    // 计算 item 的 x 坐标
                    let itemX: CGFloat = leftMargin + CGFloat(itemColumn) * (columnMargin + itemW)
                    var itemY: CGFloat = 0
                    
                    if maxYOfItemColumn == maxY {
                        itemY = maxYOfItemColumn + topMargin
                    } else {
                        itemY = maxYOfItemColumn + rowMargin
                    }
                    
                    let frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                    itemFrames.append(frame)
                    maxYOfColumns[itemColumn] = frame.maxY
                }
                
                self.itemFrames[sectionIndex] = itemFrames
                
                // 计算当前最大Y值
                maxY = maxYOfColumns[0]
                for i in 0 ..< maxYOfColumns.count {
                    if maxY < maxYOfColumns[i] {
                        maxY = maxYOfColumns[i]
                    }
                }
                
                maxY = maxY + bottomMargin
                
                if let sectionFooterView = self.flowDelegate?.viewForSectionFooter(in: self, at: sectionIndex) {
                    let footerFrame = CGRect(x: 0, y: maxY, width: self.bounds.width, height: sectionFooterView.frame.height)
                    self.sectionFooterFrames[sectionIndex] = footerFrame
                    maxY = footerFrame.maxY
                }
            }
            
            self.contentSize = CGSize(width: 0, height: maxY)
            self.setNeedsLayout()
    }
    
    // 从缓存池中获取 item
    func dequeueReuseableItem(with identifier: String) -> TIMFlowViewItem? {
        var reuseItem: TIMFlowViewItem?
        for (_, var value) in reuseableItems {
            for (_, item) in value.enumerated() {
                if item.reuseIdentifier == identifier {
                    reuseItem = item
                    break
                }
            }
            
            if reuseItem != nil {
                value.remove(reuseItem!)
                break
            }
        }
        
        return reuseItem
    }
    
    // 从缓存池中获取分区头视图
    func dequeueReuseableSectionHeaderView<Header: TIMFlowHeaderFooterView>(with identifier: String) -> Header? {
        var reuseHeader: Header?
        for (_, header) in reuseableSectionHeader.enumerated() {
            if header.reuseIdentifier == identifier {
                reuseHeader = header as? Header
                break
            }
        }
        
        if reuseHeader != nil {
            reuseableSectionHeader.remove(reuseHeader!)
        }
        
        return reuseHeader
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flowDelegate == nil {
            return
        }
        
        guard let touch = (touches as NSSet).anyObject() as? UITouch else {
            return
        }
        
        let point = touch.location(in: self)
        var selectedIndexPath: TIMIndexPath? = nil
        for (key, value) in displayingItems {
            if value.frame.contains(point) {
                selectedIndexPath = key
                break
            }
        }
        
        if selectedIndexPath != nil {
            flowDelegate?.didSelected(in: self, at: selectedIndexPath!)
        }
    }
}

// MARK: - Private API
extension TIMFlowView {
    private func isInScreen(aFrame: CGRect) -> Bool {
        (aFrame.maxY > contentOffset.y) && (aFrame.minY < (contentOffset.y + bounds.height))
    }
    
    
    private func margin(at section: Int, for type: TIMFlowViewCellMarginType) -> CGFloat {
        if let margin = flowDelegate?.margin(in: self, at: section, for: type) {
            return margin
        }
        
        return DEFAULT_CELL_MARGIN
    }
    
    
    
    private func numberOfColumns(section: Int) -> Int {
        if let columns = flowDataSource?.numberOfColumns(in: self, at: section){
            return columns
        }
        
        return DEFAULT_COLUMN_COUNT
    }
    
    private func height(at indexPath: TIMIndexPath) -> CGFloat {
        
        if let height = flowDelegate?.itemHeight(in: self, at: indexPath) {
            return height
        }
        
        return DEFAULT_CELL_HEIGHT
    }
}


extension TIMFlowView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if floatingHeaderEnable {
            
            if currentFloatingIndex >= needFloatingHeader.count || currentFloatingIndex < 0 {
                return
            }
            
            offsetY = contentOffset.y
            
            if offsetY <= 0 {
                return
            }
            
            if offsetY >= floatingBeginY {
                guard let floatingHeader = needFloatingHeader[currentFloatingIndex] else {
                    return
                }
                
                floatingHeader.frame = CGRect(x: 0, y: frame.minY, width: floatingHeader.bounds.width, height: floatingHeader.bounds.height)
                
                superview?.addSubview(floatingHeader)
                
                // 取出当前索引分区内的item的frames，并获取当前分区的最大Y值
                var sectionMaxY: CGFloat! = 0
                if sectionFooterFrames[currentFloatingIndex] != nil {
                    sectionMaxY = sectionFooterFrames[currentFloatingIndex]?.maxY
                } else {
                    if let itemFrames = itemFrames[currentFloatingIndex] {
                        for i in 0 ..< itemFrames.count {
                            sectionMaxY < itemFrames[i].maxY ? (sectionMaxY = itemFrames[i].maxY) : (sectionMaxY = sectionMaxY)
                        }
                        
                        sectionMaxY += flowDelegate?.margin(in: self, at: currentFloatingIndex, for: .bottom) ?? 0
                    }
                }
                
                if offsetY >= (sectionMaxY - floatingHeader.bounds.height) && offsetY < sectionMaxY {
                    let animationY = currentFloatingHeaderView!.frame.minY - (offsetY - (sectionMaxY - floatingHeader.bounds.height))
                    currentFloatingHeaderView?.frame = CGRect(x: 0, y:animationY , width: currentFloatingHeaderView!.bounds.width, height: currentFloatingHeaderView!.bounds.height)
                }
                
                if offsetY > sectionMaxY {
                    
                    currentFloatingHeaderView?.frame = (sectionHeaderFrames[currentFloatingIndex])!
                    addSubview(currentFloatingHeaderView!)
                    
                    currentFloatingIndex += 1
                    floatingBeginY = sectionMaxY
                }
                
                currentFloatingHeaderView = floatingHeader
            } else {
                // 获取当前索引分区的最小 Y 值
                guard let minY = sectionHeaderFrames[currentFloatingIndex]?.minY else {
                    return
                }
                
                
                if offsetY <= minY && currentFloatingIndex != 0 {
                    currentFloatingHeaderView?.frame = sectionHeaderFrames[currentFloatingIndex]!
                    addSubview(currentFloatingHeaderView!)
                    
                    currentFloatingIndex -= 1
                    floatingBeginY = (sectionHeaderFrames[currentFloatingIndex]?.minY)!
                }
                
                guard let floatingHeader = needFloatingHeader[currentFloatingIndex] else {
                    return
                }
                
                floatingHeader.frame = CGRect(x: 0, y: frame.minY, width: floatingHeader.bounds.width, height: floatingHeader.bounds.height)
                superview?.addSubview(floatingHeader)
                currentFloatingHeaderView = floatingHeader
                
                if currentFloatingIndex == 0 && currentFloatingHeaderView != nil {
                    currentFloatingHeaderView?.frame = sectionHeaderFrames[currentFloatingIndex]!
                    addSubview(currentFloatingHeaderView!)
                }
                
            }
        }
    }
}
