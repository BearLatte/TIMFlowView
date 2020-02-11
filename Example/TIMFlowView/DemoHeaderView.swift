//
//  DemoHeaderView.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import TIMFlowView

class DemoHeaderView: UIView {
    
    
    class func headerView(with height: CGFloat, tapAction: @escaping (_ index: Int) -> Void) -> DemoHeaderView {
        let headerView = self.init()
        headerView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
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
        cycleView.frame = CGRect(x: 8.0, y: 8.0, width: frame.width - 2 * 8.0, height: frame.height - 2 * 8.0)
    }
    
    private func setupBannerView() {
        
        let cycleView = ZCycleView()
        cycleView.delegate = self
        cycleView.isInfinite = true
        cycleView.isAutomatic = true
        cycleView.timeInterval = 3
        cycleView.setImagesGroup([#imageLiteral(resourceName: "banner03"), #imageLiteral(resourceName: "banner01"), #imageLiteral(resourceName: "banner02")])
        cycleView.itemSpacing = 0
        cycleView.itemSize = CGSize(width: kScreenWidth - 2 * 8.0, height: kScreenWidth * 0.56 - 2 * 8.0)
        cycleView.layer.cornerRadius = 8.0
        addSubview(cycleView)
        self.cycleView = cycleView
        
    }
    
    private var cycleView: ZCycleView!
    private var tapAction: ((Int) -> ())?
}

extension DemoHeaderView: ZCycleViewProtocol {
    func cycleViewConfigureDefaultCellImage(_ cycleView: ZCycleView, imageView: UIImageView, image: UIImage?, index: Int) {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        imageView.image = image
    }
    
    func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int) {
        tapAction!(index)
    }
}
