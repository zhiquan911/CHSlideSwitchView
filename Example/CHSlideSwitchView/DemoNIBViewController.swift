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
//        self.initTestViewDatas()
        
        self.slideSwitchView.slideItems = self.datas
    }

    
    /// 初始化测试数据-View
    func initTestViewDatas() {
        for (i, color) in self.colors.enumerated() {
            let item = CHSlideItem(key: i, title: titles[i], content: CHSlideItemType.view({ () -> UIView in
                let view = UIView()
                view.backgroundColor = color
                return view
            }))
            self.datas.append(item)
        }
    }
    
    // 初始化测试数据-ViewController
    func initTestVCDatas() {
        for (i, _) in self.colors.enumerated() {
            let item = CHSlideItem(key: i, title: titles[i], content: CHSlideItemType.viewController({ () -> UIViewController in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "DemoSelectViewController") as! DemoSelectViewController
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
}

extension DemoNIBViewController: CHSlideSwitchViewDelegate {
    
    /// 视图加载总数
    ///
    /// - Parameter view: 组件对象
    /// - Returns: 视图加载总数
    func numberOfSlideSwitchView(view: CHSlideSwitchView) -> Int {
        return self.colors.count
    }

    
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
    
    /// 顶部Tabbar高度
    ///
    /// - Parameter view: 组件对象
    /// - Returns: 自定义高度
    func heightOfSlideHeaderView(view: CHSlideSwitchView) -> CGFloat {
        return 35
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
}
