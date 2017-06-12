//
//  CHSlideSwitchViewDelegate.swift
//  Pods
//
//  Created by Chance on 2017/6/5.
//
//

import Foundation

/// 代理方法
@objc
public protocol CHSlideSwitchViewDelegate: class {
    
    /// 滑动左右边界时传递手势
    ///
    /// - Parameters:
    ///   - view: 组件对象
    ///   - direction: 方向， true：左，false：右
    ///   - panEdge: 手势
    @objc optional func slideSwitchView(view: CHSlideSwitchView, direction: Bool, panEdge: UIPanGestureRecognizer)
    
    
    /// 点击顶部tab
    ///
    /// - Parameters:
    ///   - view: 组件对象
    ///   - atIndex: 点击位置
    @objc optional func slideSwitchView(view: CHSlideSwitchView, didSelected atIndex: Int)
    
}
