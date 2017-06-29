//
//  UIView+CHSlideSwitchView.swift
//  Pods
//
//  Created by Chance on 2017/6/8.
//
//

import Foundation


// MARK: - 形状坐标相关
extension UIView {
    
    var x: CGFloat {
        set {
            var frame = self.frame;
            frame.origin.x = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            var frame = self.frame;
            frame.origin.y = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var centerX: CGFloat {
        set {
            var center = self.center;
            center.x = newValue;
            self.center = center;
        }
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            var center = self.center;
            center.y = newValue;
            self.center = center;
        }
        get {
            return self.center.y
        }
    }
    
    var width: CGFloat {
        set {
            var frame = self.frame;
            frame.size.width = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var frame = self.frame;
            frame.size.height = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size.height
        }
    }
    
    var size: CGSize {
        set {
            var frame = self.frame;
            frame.size = newValue;
            self.frame = frame;
        }
        get {
            return self.frame.size
        }
    }
}


// MARK: - 支持slideSwitchView的扩展
public extension UIView {
    
    /// 获取视图的父级CHSlideSwitchView
    public var ch_slideSwitchView: CHSlideSwitchView? {
        return self.superview as? CHSlideSwitchView
    }
    
    /// 寻找View所属的controller
    ///
    /// - returns:
    func ch_controller() -> UIViewController? {
        var father = self.superview
        while father != nil {
            if let nextResponder = father?.next, nextResponder is UIViewController {
                return nextResponder as? UIViewController
            }
            father = father?.superview
        }
        return nil
    }
}
