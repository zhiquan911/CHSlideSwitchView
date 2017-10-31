# CHSlideSwitchView

[![CI Status](http://img.shields.io/travis/zhiquan911/CHSlideSwitchView.svg?style=flat)](https://travis-ci.org/zhiquan911/CHSlideSwitchView)
[![Version](https://img.shields.io/cocoapods/v/CHSlideSwitchView.svg?style=flat)](http://cocoapods.org/pods/CHSlideSwitchView)
[![License](https://img.shields.io/cocoapods/l/CHSlideSwitchView.svg?style=flat)](http://cocoapods.org/pods/CHSlideSwitchView)
[![Platform](https://img.shields.io/cocoapods/p/CHSlideSwitchView.svg?style=flat)](http://cocoapods.org/pods/CHSlideSwitchView)

## Example

```swift

@IBOutlet var slideSwitchView: CHSlideSwitchView!

var datas = [CHSlideItem]()

var colors = [
UIColor.green,
UIColor.black,
UIColor.blue,
UIColor.yellow,
UIColor.purple,
UIColor.orange,
UIColor.magenta,
UIColor.brown,
UIColor.red
]

var titles = [
"推荐",
"热点国际新闻",
"国际",
"娱乐新闻",
"本地",
"视频",
]

lazy var addButton: UIButton = {
let btn = UIButton(type: UIButtonType.custom)
btn.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 26))
btn.backgroundColor = UIColor(white: 0.9, alpha: 1)
btn.layer.cornerRadius = 13
btn.setTitle("+", for: .normal)
btn.setTitleColor(UIColor.black, for: .normal)
btn.addTarget(self, action: #selector(self.handleAddNewTabPress(sender:)), for: UIControlEvents.touchUpInside)
return btn
}()

override func viewDidLoad() {
super.viewDidLoad()
self.slideSwitchView.delegate = self
self.slideSwitchView.headerView?.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
self.slideSwitchView.headerView?.layout = .center(halve: false)
self.slideSwitchView.headerView?.selectedStyle = .rectangle(cornerRadius: 13, height: 26, color: UIColor(white: 0.9, alpha: 1))
self.slideSwitchView.cacheSize = 10
//        self.slideSwitchView.headerView?.selectedStyle = .line(color: UIColor.red, height: 2.5)
self.initTestVCDatas()
//        self.initTestViewDatas()

self.slideSwitchView.slideItems = self.datas

self.slideSwitchView.headerView?.setAccessoryView(view: self.addButton, width: 50)
}

// 初始化测试数据-ViewController
func initTestVCDatas() {
for (i, _) in self.titles.enumerated() {
let item = CHSlideItem(title: titles[i], content: CHSlideItemType.viewController({ () -> UIViewController in
let story = UIStoryboard.init(name: "Main", bundle: nil)
let vc = story.instantiateViewController(withIdentifier: "DemoSubViewController") as! DemoSubViewController
vc.num = "\(i)"
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
