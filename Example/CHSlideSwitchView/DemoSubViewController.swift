//
//  DemoSubViewController.swift
//  CHSlideSwitchView
//
//  Created by Chance on 2017/6/8.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class DemoSubViewController: UIViewController {
    
    @IBOutlet var labelNum: UILabel!
    
    var num: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelNum.text = num
    }

}
