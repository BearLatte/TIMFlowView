//
//  TIMFlowViewCell.swift
//  TIMFlowView
//
//  Created by Tim's Mac Book Pro on 2020/1/16.
//  Copyright © 2020 Tim. All rights reserved.
//

import UIKit

open class TIMFlowViewItem: UIView {
    /// 重用标识符
    internal var reuseIdentifier: String
    
    public convenience init(with reuseIdentifier: String) {
        self.init()
        self.reuseIdentifier = reuseIdentifier
    }
    
    public override init(frame: CGRect) {
        reuseIdentifier = ""
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
