//
//  CustomerTabViewController.swift
//  CHSlideSwitchView
//
//  Created by Chance on 2017/6/12.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import CHSlideSwitchView

class CustomerTabViewController: UIViewController {

    @IBOutlet var slideSwitchView: CHSlideSwitchView!
    
    var datas = [CHSlideItem]()
    
    var currencyType: [String] = [
        "新闻",
        "视频",
        "体育",
        "国内",
        "国际",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideSwitchView.delegate = self
        self.slideSwitchView.headerView?.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.slideSwitchView.headerView?.layout = .average(max: 4)
        self.slideSwitchView.headerView?.selectedStyle = .rectangle(cornerRadius: 22, height: 44, color: UIColor(white: 0, alpha: 0.5))
        self.slideSwitchView.headerView?.backgroundColor = UIColor.white
        self.slideSwitchView.headerView?.selectedScale = 1
        self.slideSwitchView.headerView?.tabType = .view
        self.initTestVCDatas()
        //        self.initTestViewDatas()
        
        self.slideSwitchView.slideItems = self.datas
    }
    
    
    // 初始化测试数据-ViewController
    func initTestVCDatas() {
        for (i, _) in self.currencyType.enumerated() {
            
            let tabbarItem = UIView.loadFromNibNamed("CustomView") as! CustomView
            tabbarItem.labelTab.text = self.currencyType[i]
            
            let item = CHSlideItem(tabView: tabbarItem, content: CHSlideItemType.viewController({ () -> UIViewController in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "DemoSelectViewController") as! DemoSelectViewController
                return vc
            }))
            self.datas.append(item)
        }
    }

}

extension CustomerTabViewController: CHSlideSwitchViewDelegate {
    
    
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
}

