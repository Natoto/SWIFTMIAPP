Swiftmi-APP (Dev Share)
=========

**Dev Share**为[www.swiftmi.com](http://www.swiftmi.com) 社区app(已上线),纯Swift实现，
Natoto加入pod，使用Alamofire、喵神的Kingfisher和 SwiftyJSON
========
`platform :ios, "8.0"`
`use_frameworks!`
`pod 'Kingfisher', '~> 1.6.0'`
`pod 'SwiftyJSON', '~> 2.3.0'`
`pod 'Alamofire', '~> 2.0.2'`
========
运行前获取以上的第三方库
`pod install --no-repo-update`

##Screenshots
![demo](swiftmi.gif)

##build

程序中 [Alamofire](https://github.com/Alamofire/Alamofire)、[Kingfisher](https://github.com/onevcat/Kingfisher)、[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) 为submodule引用方式
 

 
##更新

- 20150711  **增加handoff**：在内容(主题、源代码)详情界面阅读时增加handoff,支持mac 默认浏览器打开阅读详情
- 2015092  升级Swift2.0,Xcode7.0编译下通过

##环境

- Xcode 7.0 编译通过
- Swift 2.0
 
 

