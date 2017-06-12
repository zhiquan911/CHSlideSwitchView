//
//  CurrencyPriceView.swift
//  chbtc
//
//  Created by 麦志泉 on 16/4/22.
//  Copyright © 2016年 bitbank. All rights reserved.
//

import UIKit

class CurrencyPriceView: UIView {

    @IBOutlet var labelCurrency: UILabel!
    @IBOutlet var labelPrice: UILabel!
    @IBOutlet var labelRate: UILabel!
    @IBOutlet var imageViewTrend: UIImageView!
    
    @IBInspectable var rate: Float = 0 {
        didSet {
            self.labelRate.text = "\(rate)%"
        }
    }
    
    @IBInspectable var currencyPrice: String = "0.0" {
        didSet {
            
            self.labelPrice.text = "￥" + currencyPrice
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
