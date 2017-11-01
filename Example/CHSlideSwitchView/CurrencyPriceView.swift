//
//  CurrencyPriceView.swift
//  chbtc
//
//  Created by 麦志泉 on 16/4/22.
//  Copyright © 2016年 bitbank. All rights reserved.
//

import UIKit

class CustomView: UIView {

    @IBOutlet var labelTab: UILabel!
    
    var title: String = "" {
        didSet {
            self.labelTab.text = self.title
        }
    }
    
    var selected: Bool = false {
        didSet {
            if self.selected {
                //选中高亮
                self.labelTab.backgroundColor = UIColor(hex: 0xff9000)
                self.labelTab.textColor = UIColor.white
                
            } else {
                
                self.labelTab.backgroundColor = UIColor(hex: 0x363a43)
                self.labelTab.textColor = UIColor.lightText
                
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.selected {
            //选中高亮
            self.labelTab.backgroundColor = UIColor(hex: 0xff9000)
            self.labelTab.textColor = UIColor.white
            
        } else {
            
            self.labelTab.backgroundColor = UIColor(hex: 0x363a43)
            self.labelTab.textColor = UIColor.lightText
            
        }
        
        // 圆角
        self.labelTab.layer.cornerRadius = self.labelTab.frame.size.height / 2
        self.labelTab.layer.masksToBounds = true
    }

}

//MARK：全局方法
extension UIView {
    
    //读取nib文件
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
