//
//  TIMFlowViewUtils.swift
//  TIMFlowView
//
//  Created by Tim's Mac Book Pro on 2020/1/16.
//  Copyright © 2020 Tim. All rights reserved.
//  一些常量值

/// 瀑布流默认列数
internal let DEFAULT_COLUMN_COUNT          = 2

/// cell 的默认高度
internal let DEFAULT_CELL_HEIGHT: CGFloat  = 70.0

/// 默认间距
internal let DEFAULT_CELL_MARGIN: CGFloat  = 8.0

/// 当前设备是否为 iPhone X 系列
public let isIphoneX = kScreenHeight >= 812

/// 状态栏高度
public let kStatusBarHeight : CGFloat = isIphoneX ? 44.0 : 20.0

/// 导航栏高度
public let kNavigationBarHeight : CGFloat = (kStatusBarHeight + 44.0)

/// tabBar 高度
public let kTabBarHeight : CGFloat = (kStatusBarHeight == 20.0) ? 49.0 : 83.0

/// 顶部安全距离
public let kTopSafeArea  = (kStatusBarHeight - 20.0)

/// 底部安全距离
public let kBottomSafeArea = kTabBarHeight - 49.0

/// 快速获取屏幕的Bounds属性
public let kScreenBounds = UIScreen.main.bounds

/// 屏幕宽度
public let kScreenWidth = kScreenBounds.width

/// 屏幕高度
public let kScreenHeight = kScreenBounds.height

/// 屏幕宽高
public let kScreenSize   = kScreenBounds.size

/// 分辨率缩放比例
public let kScreenScale = UIScreen.main.scale

/// 客服QQ
public let kCustomerServiceQQ = "800184955"

