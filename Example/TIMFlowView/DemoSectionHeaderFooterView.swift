//
//  DemoSectionHeaderFooterView.swift
//  TIMFlowView_Example
//
//  Created by Tim on 2020/2/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import TIMFlowView

class DemoSectionHeaderFooterView: TIMFlowHeaderFooterView {
    var sectionIndex: Int? {
        willSet {
            titleLabel.text = "当前第\(String(describing: newValue))个分区"
        }
    }
    
    class func headerFooterView(with flowView: TIMFlowView) -> DemoSectionHeaderFooterView? {
        let headerFooterID = "headerFooterID"
        guard let headerFooterView = flowView.dequeueReuseableSectionHeaderView(with: headerFooterID) else {
            let hfView = DemoSectionHeaderFooterView(with: headerFooterID)
            hfView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            hfView.frame = CGRect(x: 0, y: 0, width: 0, height: 44.0)
            return hfView
        }
        
        return headerFooterView as? DemoSectionHeaderFooterView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14.0)
        title.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(title)
        titleLabel = title
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15.0, y: 0, width: bounds.width - 2 * 15.0, height: bounds.height)
    }
    
    
    private weak var titleLabel: UILabel!
}
