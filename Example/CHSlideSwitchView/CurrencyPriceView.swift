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
