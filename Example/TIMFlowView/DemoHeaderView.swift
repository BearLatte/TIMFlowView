//
//  DemoHeaderView.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import TIMFlowView

class DemoHeaderView: TIMFlowHeaderView {
    
    
    class func headerView(with height: CGFloat, tapAction: @escaping (_ index: Int) -> Void) -> DemoHeaderView {
        let headerView = self.init(height: height)
        headerView.tapAction = tapAction
        return headerView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBannerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = CGRect(x: 8.0, y: 8.0, width: frame.width - 2 * 8.0, height: frame.height - 2 * 8.0)
        cycleView.frame = contentView.bounds
        cycleView.itemSize = contentView.bounds.size
    }
    
    private func setupBannerView() {
        contentView.layer.cornerRadius = 8.0
        
        let cycleView = ZCycleView()
        cycleView.delegate = self
        cycleView.isInfinite = true
        cycleView.isAutomatic = true
        cycleView.timeInterval = 3
        cycleView.setImagesGroup([#imageLiteral(resourceName: "banner03"), #imageLiteral(resourceName: "banner01"), #imageLiteral(resourceName: "banner02")])
        cycleView.itemSpacing = 0
        contentView.addSubview(cycleView)
        self.cycleView = cycleView
        
    }
    
    private var cycleView: ZCycleView!
    private var tapAction: ((Int) -> ())? = nil
}

extension DemoHeaderView: ZCycleViewProtocol {
    func cycleViewConfigureDefaultCellImage(_ cycleView: ZCycleView, imageView: UIImageView, image: UIImage?, index: Int) {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        imageView.image = image
    }
}
