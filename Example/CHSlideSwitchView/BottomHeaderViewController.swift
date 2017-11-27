//
//  BottomHeaderViewController.swift
//  CHSlideSwitchView_Example
//
//  Created by Chance on 2017/11/27.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import CHSlideSwitchView

class BottomHeaderViewController: UIViewController {
    
    var datas = [CHSlideItem]()
    
    var colors = [
        UIColor.green,
        UIColor.black,
        UIColor.blue,
        UIColor.yellow,
        UIColor.purple,
        UIColor.orange,
    ]
    
    var titles = [
        "Locals",
        "Wechat",
        "QQ",
        "Alipay",
        "163",
        "BTC",
        ]
    
    lazy var slideView: CHSlideSwitchView = {
        let view = CHSlideSwitchView(frame: CGRect.zero, integrateHeader: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isIntegrateHeaderView = false
        view.headerView = self.footerView
        view.loadAll = true
        view.cacheSize = 6
        
        self.initTestViewDatas()
        
        view.slideItems = self.datas
        
        self.view.addSubview(view)
        return view
    }()
    
    lazy var footerView: CHSlideHeaderView = {
        let view = CHSlideHeaderView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setAccessoryView(view: self.sendButton, width: 60)
        view.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.layout = .center(halve: false)
        view.selectedStyle = .rectangle(cornerRadius: 13, height: 26, color: UIColor(white: 0.9, alpha: 1))
        
        self.view.addSubview(view)
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 26))
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1)
        btn.layer.cornerRadius = 13
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        //        btn.addTarget(self, action: #selector(self.handleAddNewTabPress(sender:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var toolbarBottomConstraint: NSLayoutConstraint!
    
    var isShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraint()
    }
    
    func setupConstraint() {
        
        self.slideView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.slideView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.slideView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        self.toolbar.bottomAnchor.constraint(equalTo: self.slideView.topAnchor).isActive = true
        
        self.footerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.footerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.footerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.slideView.bottomAnchor.constraint(equalTo: self.footerView.topAnchor).isActive = true
        
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
    
    @IBAction func handleShow(sender: Any?) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.toolbarBottomConstraint.constant = self.isShow ? 0 : 260
            self.view.layoutIfNeeded()
            
        }) { (flag) in
            self.isShow = !self.isShow
        }
    }
    
}
