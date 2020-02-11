# TIMFlowView
[![CI Status](https://img.shields.io/travis/Tim/TIMFlowView.svg?style=flat)](https://travis-ci.org/Tim/TIMFlowView)
[![Version](https://img.shields.io/cocoapods/v/TIMFlowView.svg?style=flat)](https://cocoapods.org/pods/TIMFlowView)
[![License](https://img.shields.io/cocoapods/l/TIMFlowView.svg?style=flat)](https://cocoapods.org/pods/TIMFlowView)
[![Platform](https://img.shields.io/cocoapods/p/TIMFlowView.svg?style=flat)](https://cocoapods.org/pods/TIMFlowView)

## 写在前面

写这个视图的初衷在于公司的产品对于`UITableView`悬停的 `SectionHeader`有近乎执着的爱，并且给出的设计瀑布流居多，多次沟通无果，决定自己动手解决，本项目的思路来源于`UITableView`，并且采用了模仿`UITableView`的数据源和代理协议实现，只要你会用`UITableView`那就一定会使用本项目。以下为本项目支持的操作：

- [x] 分区显示
- [x] 分区头和分区尾部视图
- [x] 分区头部滑动悬停
- [x] 头视图和尾视图
- [x] 九宫格视图（参考 UICollectionView）
- [x] 瀑布流视图（参考网易云音乐广场功能）

- [x] 

## Example

具体的代码操作烦请阅读 demo 中的代码或者项目源代码解决，运行 demo 可以得到如下的结果：

![普通瀑布流视图](/Users/tim/Development/TIMFlowView/ExampleImages/普通瀑布流.gif)![带有header的瀑布流](/Users/tim/Development/TIMFlowView/ExampleImages/带有header的瀑布流.gif)![全部功能开启](/Users/tim/Development/TIMFlowView/ExampleImages/全部功能开启.gif)

## Requirements

- Xcode 10.0 ~>
- Swift 4.0 ~>

## Installation

本项目推荐使用 [Cocoapods](https://cocoapods.org) 引入，引入方法：

```ruby
# 如果是 Cocoapods 1.8.0 版本或以上的用户请添加 CocoaPods 源在你的 Podfile 文件最顶部添加
source 'https://github.com/CocoaPods/Specs.git'		# 添加这一句，不然会报 cdn 错误

target 'xxx' do
	pod 'TIMFlowView'
end
```

之后打开命令行工具执行 `pod install` 或者 `pod update`。

除此之外还可以通过源代码的方式进行导入：

- 将项目通过 zip 的形式下载下来并解包；
- 将 `TIMFlowView` 文件夹拖入你项目中的某个路径下（不要忘记勾选 copy item if needed 复选框）。

## Useg

- 具体使用方式见 Demo 或者项目源代码中的注释。

## Author

有任何问题欢迎大家提 issue，或者联系我本人，以下是邮箱和微信：

- Email:  guoyong19890907@gmail.com
- Wechat: 2625991041

## License

TIMFlowView is available under the MIT license. See the LICENSE file for more info.
