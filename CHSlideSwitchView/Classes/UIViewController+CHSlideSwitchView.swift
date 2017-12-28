//
//  UIViewController+CHSlideSwitchView.swift
//  Pods
//
//  Created by Chance on 2017/6/9.
//
//

import Foundation

public extension UIViewController {
    
    //在扩展中通过key来定义成员变量
    fileprivate struct AssociatedKeys {
        static var ch_slideSwitchView = "ch_slideSwitchView"
    }
    
    /// 获取视图的父级CHSlideSwitchView
    var ch_slideSwitchView: CHSlideSwitchView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ch_slideSwitchView) as? CHSlideSwitchView
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.ch_slideSwitchView,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN
            )
        }
    }
    
}
