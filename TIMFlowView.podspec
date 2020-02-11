

Pod::Spec.new do |s|
  s.name             = 'TIMFlowView'
  s.version          = '1.0.0'
  s.summary          = 'Swift 模仿 UITableView 写的一个瀑布流视图'

  s.description      = <<-DESC
  完全模仿 UITableView 实现的瀑布流视图，支持分区显示、添加分区头尾视图，添加视图头尾视图，九宫格视图、瀑布流视图，分区头滑动悬停等操作。
                       DESC

  s.homepage         = 'https://github.com/BearLatte/TIMFlowView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tim' => 'guoyong19890907@gmail.com'}
  s.source           = { :git => 'https://github.com/BearLatte/TIMFlowView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version    = '5.0'
  s.source_files = 'TIMFlowView/*.Swift'
end
