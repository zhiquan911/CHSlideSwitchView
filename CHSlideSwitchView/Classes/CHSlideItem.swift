//
//  CHSlideItem.swift
//  Pods
//
//  Created by Chance on 2017/6/5.
//
//

import Foundation

///
/// 标签元素类型
///
/// - view: 视图
/// - viewController: 视图控制器
public enum CHSlideItemType {
    
    public typealias GetViewController = () -> UIViewController
    public typealias GetView = () -> UIView
    
    case view(GetView)
    case viewController(GetViewController)
    
    
    /// 通过block获取实体
    var entity: AnyObject {
        switch self {
        case let .view(block):
            return block()
        case let .viewController(block):
            return block()
        }
    }
    
}


/// Tab实体类型
///
/// - text: 文字，组件使用默认的View样式展示文字，默认颜色，选中效果
/// - view: 自定义View
public enum CHSlideTabType {
    
    
    case text
    case view

}


/// 标签元素定义
public class CHSlideItem {
    
    /// 标签
    public var key: Int = 0
    
    /// 标题
    public var title: String = ""
    
    /// 标签View
    public var tabView: UIView?
    
    /// 类型
    public var content: CHSlideItemType!
    
    
    public convenience init(key: Int, title: String = "", tabView: UIView? = nil, content: CHSlideItemType) {
        self.init()
        self.key = key
        self.title = title
        self.tabView = tabView
        self.content = content
    }
    
}
