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
    
    
    /// 是否为当前页面提供手势滑动
    ///
    /// - Parameters:
    ///   - view: 组件对象
    ///   - atIndex: 当前位置
    /// - Returns: 是否可以滑动
    @objc optional func slideSwitchView(view: CHSlideSwitchView, canSwipeScroll atIndex: Int) -> Bool
    
}


/// 子视图的协议，用于回调给子视图的【出现】【消失】两种业务处理情况
@objc
public protocol CHSlideSwitchSubViewDelegate: class {
    
    /// 子视图出现
    @objc optional func subViewDidAppear(parent: CHSlideSwitchView)
    
    /// 子视图消失
    @objc optional func subViewDidDisappear(parent: CHSlideSwitchView)
}
