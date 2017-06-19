//
//  DemoViewController.swift
//  CHSlideSwitchView
//
//  Created by Chance on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import CHSlideSwitchView

class DemoNIBViewController: UIViewController {
    
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

    
    /// 初始化测试数据-View
    func initTestViewDatas() {
        for (i, color) in self.colors.enumerated() {
            let item = CHSlideItem(title: titles[i], content: CHSlideItemType.view({ () -> UIView in
                let view = UIView()
                view.backgroundColor = color
                return view
            }))
            self.datas.append(item)
        }
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
    
    @IBAction func handleUpdateTabPress(sender: AnyObject?) {
        self.slideSwitchView.headerView?.updateTab(at: 3, block: {
            (view, item) -> CHSlideItem in
            let btn = view as! UIButton
            item.title = "janme"
            btn.setTitle("janme", for: .normal)
            return item
        })
    }
    
    
    /// 添加新的标签到原有标签组中
    ///
    /// - Parameter sender:
    @IBAction func handleAddNewTabPress(sender: AnyObject?) {
        let item = CHSlideItem(title: "体育新闻", content: CHSlideItemType.viewController({ () -> UIViewController in
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "DemoSubViewController") as! DemoSubViewController
            vc.num = "2-体育新闻"
            return vc
        }))
        
        self.slideSwitchView.insertTab(item: item, at: 2, isSelected: true)
    }
}

extension DemoNIBViewController: CHSlideSwitchViewDelegate {
    
    
    /// 视图数据源
    ///
    /// - Parameters:
    ///   - view: 组件对象
    ///   - index: 视图索引
    /// - Returns: 加载视图对象
    func slideSwitchView(view: CHSlideSwitchView, itemForIndexAt index: Int) -> CHSlideItem {
        let item = self.datas[index]
        return item
    }
    
    /// 点击顶部tab
    ///
    /// - Parameters:
    ///   - view: 组件对象
    ///   - atIndex: 点击位置
    func slideSwitchView(view: CHSlideSwitchView, didSelected atIndex: Int) {
        NSLog("didSelected : \(atIndex)")
    }
    
    
    /// 滑动左右边界时传递手势
    ///
    /// - Parameters:
    ///   - view: 组件对象
    ///   - direction: 方向， true：左，false：右
    ///   - panEdge: 手势
    func slideSwitchView(view: CHSlideSwitchView, direction: Bool, panEdge: UIPanGestureRecognizer) {
        
    }
    
    func slideSwitchView(view: CHSlideSwitchView, canSwipeScroll atIndex: Int) -> Bool {
//        if atIndex == 3 {
//            return false
//        }
        return true
    }
}
