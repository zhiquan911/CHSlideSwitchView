# CHSlideSwitchView

[![CI Status](http://img.shields.io/travis/zhiquan911/CHSlideSwitchView.svg?style=flat)](https://travis-ci.org/zhiquan911/CHSlideSwitchView)
[![Version](https://img.shields.io/cocoapods/v/CHSlideSwitchView.svg?style=flat)](http://cocoapods.org/pods/CHSlideSwitchView)
[![License](https://img.shields.io/cocoapods/l/CHSlideSwitchView.svg?style=flat)](http://cocoapods.org/pods/CHSlideSwitchView)
[![Platform](https://img.shields.io/cocoapods/p/CHSlideSwitchView.svg?style=flat)](http://cocoapods.org/pods/CHSlideSwitchView)

## Example

```swift

    var titles = [
        "推荐",
        "热点",
        "国际新闻",
        "段子",
        "国际新闻",
        "段子",
        "国际新闻",
        "段子",
        "国际新闻"
    ]

    override func viewDidLoad() {
    super.viewDidLoad()
        self.slideSwitchView.delegate = self
        self.slideSwitchView.headerView?.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.slideSwitchView.headerView?.layout = .center
        self.slideSwitchView.headerView?.selectedStyle = .rectangle(cornerRadius: 13, height: 26, color: UIColor(white: 0.9, alpha: 1))
        //        self.slideSwitchView.headerView?.selectedStyle = .line(color: UIColor.red, height: 2.5)
        self.initTestVCDatas()

        self.slideSwitchView.slideItems = self.datas
    }


    // 初始化测试数据-ViewController
    func initTestVCDatas() {
        for (i, _) in self.titles.enumerated() {
            let item = CHSlideItem(key: i, title: titles[i], content: CHSlideItemType.viewController({ () -> UIViewController in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "DemoSelectViewController") as! DemoSelectViewController
                return vc
            }))
            self.datas.append(item)
        }
    }

```

## Requirements

## Installation

CHSlideSwitchView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CHSlideSwitchView"
```

## Author

zhiquan911, zhiquan911@qq.com

## License

CHSlideSwitchView is available under the MIT license. See the LICENSE file for more info.
