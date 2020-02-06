//
//  TIMFlowHeaderFooterView.swift
//  TIMFlowView
//
//  Created by Tim on 2020/2/7.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

open class TIMFlowHeaderFooterView: UIView {

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
