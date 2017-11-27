//
//  DemoSelectViewController.swift
//  CHSlideSwitchView
//
//  Created by Chance on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class DemoSelectViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let demoVC: [String] = [
        "DemoNIBViewController",
        "HeaderViewNIBViewController",
        "CustomerTabViewController",
        "BottomHeaderViewController",
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


}

extension DemoSelectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demoVC.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "DemoCell")
        }
        cell?.textLabel?.text = self.demoVC[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let name = self.demoVC[indexPath.row]
        let vc = story.instantiateViewController(withIdentifier: name)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
