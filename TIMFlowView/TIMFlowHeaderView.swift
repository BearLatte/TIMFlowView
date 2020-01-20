//
//  TIMFlowHeaderView.swift
//  KakaJSON
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  头视图

import UIKit

open class TIMFlowHeaderView: UIView {
    /// 内容视图，默认 frame 与 headerView 一样
    /// 可以通过修改 frame 达到想要的效果
    public weak var contentView: UIView!
    
    public required convenience init(height: CGFloat) {
        let frame = CGRect(x: 0, y: 0, width: 0, height: height)
        self.init(frame: frame)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let content = UIView()
        addSubview(content)
        contentView = content
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
}
