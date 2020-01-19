//
//  FlowDemoCell.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import TIMFlowView
import Kingfisher

class FlowDemoCell: TIMFlowViewCell {
    
    /// 模型
    var flowModel: FlowModel? {
        willSet {
            nameLabel.text = newValue?.name
            let imageURL = URL(string: newValue?.url ?? "")
            imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    class func cell(with flowView: TIMFlowView) -> FlowDemoCell? {
        let flowCellId = "CellID"
        guard let cell = flowView.dequeueReuseable(identifier: flowCellId) else {
            return FlowDemoCell(with: flowCellId)
        }
        return cell as? FlowDemoCell
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    
    private func setupUI() {
        let content = UIView()
        
        addSubview(content)
        contentView = content

        let image = UIImageView()
        image.contentMode = .center
        content.addSubview(image)
        imageView = image

        let name = UILabel()
        name.backgroundColor = UIColor(white: 0, alpha: 0.8)
        name.textColor = UIColor(white: 0.6, alpha: 1)
        name.font = UIFont.systemFont(ofSize: 11.0)
        name.textAlignment = .left
        content.addSubview(name)
        nameLabel = name
    }
    
    // 请务必在此方法中设置 subview 的 frame
    // 否则会因获取不到 self 的frame 造成效果显示不正常
    // 方法还在寻求解决方案
    // 如果有大神有解决方案还请来信告知
    // guoyong19890907@gmail.com
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        contentView.backgroundColor = UIColor.white
        let shapPath = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0)
        let shapLayer = CAShapeLayer()
        shapLayer.path = shapPath.cgPath
        shapLayer.frame = contentView.bounds
        contentView.layer.mask = shapLayer
        
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFit
        nameLabel.frame = CGRect(x: 0, y: bounds.height - 30.0, width: bounds.width, height: 30.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private weak var contentView: UIView!
    private weak var imageView: UIImageView!
    private weak var nameLabel: UILabel!
}
