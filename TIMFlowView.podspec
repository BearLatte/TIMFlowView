#
# Be sure to run `pod lib lint TIMFlowView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TIMFlowView'
  s.version          = '1.0.1'
  s.summary          = 'Swift 模仿 UITableView 写的一个瀑布流视图'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  完全模仿 UITableView 实现的瀑布流视图，支持分区显示、添加分区头尾视图，添加视图头尾视图，九宫格视图、瀑布流视图，分区头滑动悬停等操作。
                       DESC

  s.homepage         = 'https://github.com/Tim/TIMFlowView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tim' => 'guoyong19890907@gmail.com'' }
  s.source           = { :git => 'https://github.com/Tim/TIMFlowView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version    = '5.0'

  s.source_files = 'TIMFlowView/*.Swift'
  
  # s.resource_bundles = {
  #   'TIMFlowView' => ['TIMFlowView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
