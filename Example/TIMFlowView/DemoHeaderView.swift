//
//  DemoHeaderView.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import TIMFlowView

class DemoHeaderView: TIMFlowHeaderView {
    
    var images: [String] {
        willSet {
//            bannerView.imagePaths = newValue
        }
    }
    
    var titles: [String] {
        willSet {
//            bannerView.titles = newValue
        }
    }
    
    class func headerView(with height: CGFloat, tapAction: @escaping (_ index: Int) -> Void) -> DemoHeaderView {
        let headerView = self.init(height: height)
        headerView.tapAction = tapAction
        return headerView
    }
    
    override init(frame: CGRect) {
        images = []
        titles = []
        
        super.init(frame: frame)
        setupBannerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 8.0
        let bannerFrame = CGRect(x: margin, y: margin, width: contentView.bounds.width - 2 * margin, height: contentView.bounds.height - 2 * margin)
//        bannerView.frame = bannerFrame
    }
    
    private func setupBannerView() {
//        let banner = LLCycleScrollView.llCycleScrollViewWithFrame(.zero)
//        banner.coverImage = UIImage(named: "placeholder")?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), resizingMode: .tile)
//        banner.autoScroll = true
//        banner.autoScrollTimeInterval = 2.0
//        banner.placeHolderImage = UIImage(named: "placeholder")
//        banner.scrollDirection = .horizontal
//        banner.imageViewContentMode = .scaleAspectFit
//        contentView.addSubview(banner)
//        bannerView = banner
    }
    
//    private weak var bannerView: LLCycleScrollView!
    private var tapAction: ((Int) -> ())? = nil
}
