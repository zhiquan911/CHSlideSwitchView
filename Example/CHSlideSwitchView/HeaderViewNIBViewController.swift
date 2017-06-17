//
//  HeaderViewNIBViewController.swift
//  CHSlideSwitchView
//
//  Created by Chance on 2017/6/9.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import CHSlideSwitchView

class HeaderViewNIBViewController: UIViewController {
    
    @IBOutlet var slideSwitchView: CHSlideSwitchView!
    
    var colors = [
        UIColor.green,
        UIColor.black,
        UIColor.blue
    ]
    
    lazy var datas: [CHSlideItem] = {
        var items = [CHSlideItem]()
        for (i, color) in self.colors.enumerated() {
            let item = CHSlideItem(title: "hello", content: CHSlideItemType.viewController({
                () -> UIViewController in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "DemoNIBViewController") as! DemoNIBViewController
                return vc
            }))
            items.append(item)
        }
        return items
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideSwitchView.delegate = self
        self.slideSwitchView.headerView?.selectedStyle = .line(color: UIColor.red, height: 2.5)
        self.slideSwitchView.slideItems = self.datas

    }

    
    @IBAction func handleUpdateTabPress(sender: AnyObject?) {
        self.slideSwitchView.headerView?.updateTab(at: 1, block: {
            (view, item) -> CHSlideItem in
            let btn = view as! UIButton
            item.title = "janme"
            btn.setTitle("janme", for: .normal)
            return item
        })
    }
}

extension HeaderViewNIBViewController: CHSlideSwitchViewDelegate {
        
    
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
