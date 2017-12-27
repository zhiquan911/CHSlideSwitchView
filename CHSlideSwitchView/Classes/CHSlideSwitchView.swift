//
//  CHSlideSwitchView.swift
//  Pods
//
//  Created by Chance on 2017/6/2.
//
//

import UIKit
import SnapKit


/// 滑动时加载新视图的时机
///
/// - normal: 滑动或者动画结束
/// - scale: 根据设置滑动百分比添加0-1
public enum CHSlideLoadViewTiming {
    
    case normal
    case scale(Float)
    
    
}
//重写相等处理
public func ==(lhs: CHSlideLoadViewTiming, rhs: CHSlideLoadViewTiming) -> Bool {
    switch (lhs,rhs) {
    case (.normal,.normal) : return true
    case let (.scale(i), .scale(j)) where i == j: return true
    default: return false
    }
}

/// 滑动视图组件
open class CHSlideSwitchView: UIView {
    
    /// 顶部的标签栏
    @IBOutlet public var headerView: CHSlideHeaderView? {
        didSet {
            self.headerView?.slideSwitchView = self
        }
    }
    
    /// 是否集成顶部标签栏视图
    @IBInspectable open var isIntegrateHeaderView: Bool = true
    
    /// 主视图
    public var rootScrollView: UIScrollView!
    
    /// 内容元素组
    open var slideItems: [CHSlideItem] = [CHSlideItem]()
//    {
//        didSet {
//            
//            //数组重置，清除所有子视图
//            for i in self.viewsCache.keys {
//                self.removeViewCacheIndex(index: i)
//            }
//            
//            self.setNeedsLayout()
//        }
//    }
    
    /// 初始化显示页签位置
    open var showIndex: Int = 0
    
    /// 缓存的页面个数，越大使用内存越多
    open var cacheSize: Int = 4
    
    /// 缓存页面对象，最大数量为cacheSize值
    open var viewsCache = [Int: AnyObject]()
    
    /// 是否手势滑动
    var isPaning: Bool = false
    
    /// 代理
    @IBOutlet public weak var delegate: CHSlideSwitchViewDelegate? {
        didSet {
            //关闭UIViewController自动调整scrollInsets
            self.parent?.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    /// 是否全部视图加载
    open var loadAll: Bool = false
    
    /// 加载新视图的时机，默认动画结束时加载
    open var loadViewTiming: CHSlideLoadViewTiming = .normal
    
    /// 滚动起始的x位置
    var startOffsetX: CGFloat = 0
    
    /// 顶部标签栏高度
    @IBInspectable var heightOfHeaderView: CGFloat = 35
    
    /// 是否插入新项目
    open var isInserting: Bool = false
    
    public typealias LayoutSubViewsCompleted = () -> Void
    public var layoutSubViewsCompletedBlock: LayoutSubViewsCompleted?
    
    /// 父级控制器
    var parent: UIViewController? {
        return self.delegate as? UIViewController
    }

    
    /// 内容的高度
    var scrollHeight: CGFloat {
        return self.height - self.heightOfHeaderView
    }
    
    
    /// 当前页面位置
    fileprivate var currentIndex: Int = -1
//    {
//        didSet {
//            if oldValue != self.currentIndex {
//                self.headerView?.selectedTabView(at: self.currentIndex)
//            }
//        }
//    }
    
    
    // MARK: - 初始化方法
    
    public convenience override init(frame: CGRect) {
        self.init(frame: frame, integrateHeader: true)
    }
    
    public init(frame: CGRect, integrateHeader: Bool = true) {
        super.init(frame: frame)
        self.isIntegrateHeaderView = integrateHeader
        self.addNotification()
        self.createUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //如果你通过在XIB中设置初始化值，不要在这里做子视图的初始化，而是通过awakeFromNib
        self.addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.createUI()
    }
    
    /// 添加通知
    func addNotification() {
        
        //注册一个通知用于更新本地缓存
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.layoutSubviewsCompleted),
            name: NSNotification.Name(rawValue: "layoutSubviewsCompleted"),
            object: nil)
        
    }
    
    // MARK: - 内部方法
    
    /// 创建UI
    func createUI() {
        
        var rootViewOffetY: CGFloat = 0
        
        // 顶部View没有绑定XIB，而且需求显示Tab，就进行创建
        if self.isIntegrateHeaderView {
            self.headerView = CHSlideHeaderView()
            self.headerView?.slideSwitchView = self
            self.addSubview(self.headerView!)
            
            //设置布局
            self.headerView!.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(self.heightOfHeaderView)
                make.left.right.equalToSuperview().offset(0)
                make.top.equalToSuperview().offset(0)
            }
            
            rootViewOffetY = self.heightOfHeaderView
        }
        
        // 创建滚动主视图
        self.rootScrollView = UIScrollView()
        self.addSubview(self.rootScrollView)
        
        self.rootScrollView.backgroundColor = self.backgroundColor
        self.rootScrollView.delegate = self
        self.rootScrollView.isPagingEnabled = true
        self.rootScrollView.isUserInteractionEnabled = true
        self.rootScrollView.bounces = false
        self.rootScrollView.showsHorizontalScrollIndicator = false
        self.rootScrollView.showsVerticalScrollIndicator = false
        
        self.rootScrollView.panGestureRecognizer.addTarget(self, action: #selector(self.scrollHandlePan(pan:)))
        
        //设置布局
        self.rootScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(rootViewOffetY)
            make.left.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        
        //初始化完成后执行
        self.layoutSubViewsCompletedBlock = {
            () -> Void in
            //是否加载全部页面
            if !self.loadAll && self.self.slideItems.count > 0 {
                //只加载显示的当前页面
                self.setContentOffset(index: self.showIndex, animated: false)
                self.headerView?.isSelectTab = false
            } else {
                //在页面加载有内容时，偏移到显示的默认页面。
                if self.viewsCache.count > 0 {
                    self.updateCurrentIndex(index: self.showIndex, allowSame: true)
                }
                
            }
        }
    }
    
    
    /// 重载布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutContentView()
        
        //布局完成后通知执行的方法
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "layoutSubviewsCompleted"), object: nil)
        
        
    }
    
    
    /// 布局完成后通知执行的方法
    @objc func layoutSubviewsCompleted() {
        self.layoutSubViewsCompletedBlock?()
        self.layoutSubViewsCompletedBlock = nil //清空执行
    }
    
    /// 创建内容视图UI
    open func layoutContentView() {
        
        //如果点击Tab标签过程中视图被动执行layoutSubviews，避免动画冲突，不重设布局
        if let isSelectTab = self.headerView?.isSelectTab, isSelectTab {
            return
        }
        
        /// 设置数据源
        let viewCount = self.setDataSources()
        
        //调整子视图布局
        for (index, obj) in self.viewsCache {
            
            var targetView: UIView?
            
            switch obj {
            case let view as UIView:
                targetView = view
            case let vc as UIViewController:
                targetView = vc.view
            default:break
            }
            targetView?.frame = CGRect(x: CGFloat(index) * self.width, y: 0, width: self.width, height: self.height)
            
        }
        
        let oldContentWidth = self.rootScrollView.contentSize.width
        self.rootScrollView.contentSize = CGSize(width: CGFloat(viewCount) * self.width, height: self.scrollHeight)
        
        //宽度有变化需要重置偏移
        if oldContentWidth != self.rootScrollView.contentSize.width && oldContentWidth > 0 {
            let point = CGPoint(x: CGFloat(self.currentIndex) * self.rootScrollView.width, y: 0)
            self.setContentOffset(point, animated: false)
        }
        
        
        
    }
    
    
    /// 重新加载数据
    open func reloadData() {
        
        //数组重置，清除所有子视图
        for i in self.viewsCache.keys {
            self.removeViewCacheIndex(index: i)
        }
        
        //初始化完成后执行
        self.layoutSubViewsCompletedBlock = {
            () -> Void in
            //是否加载全部页面
            if !self.loadAll && self.self.slideItems.count > 0 {
                
                //如果当前索引溢出，选择中最后一个tab显示
                if self.currentIndex > self.slideItems.count - 1 {
                    self.showIndex = self.slideItems.count - 1
                }
                
                //只加载显示的当前页面
                self.setContentOffset(index: self.showIndex, animated: false, allowSame: true)
                self.headerView?.isSelectTab = false
            }
        }
        
        //刷新子视图布局
        self.setNeedsLayout()
        
    }
    
    /// 获取数据源
    ///
    /// - Returns:
    open func setDataSources() -> Int {
        
        let viewCount = self.slideItems.count
        
        //父级视图遇到大调整，清除所有子视图，如：横竖屏切换
//        for i in self.viewsCache.keys {
//            self.removeViewCacheIndex(index: i)
//        }
        
        if viewCount > 0 {
            
            //如果缓存数量比加载的页面多，缓存修改为页面最大数
            if self.cacheSize > viewCount {
                self.cacheSize = viewCount
            }
            
            self.showIndex = min(viewCount - 1, max(0, self.showIndex))
            
            var startIndex = 0
            
            //是否加载全部页面
            if self.loadAll {
                if viewCount - self.showIndex > self.cacheSize {
                    //缓存不足从起始位加载全部，从起始位开始加载
                    startIndex = showIndex
                } else {
                    //缓存足够从起始位加载全部，计算一个比起始位加载更多页面的位置
                    startIndex = viewCount - self.cacheSize
                }
                
                //加载页面到缓存
                for i in startIndex..<startIndex + self.cacheSize {
                    _ = self.addViewCacheIndex(index: i)
                }
                
            }
            
            
            
            //更新头部
            self.headerView?.reloadTabs(items: self.slideItems)

        }
        
        return viewCount
    }
    
    
    
    /// 添加视图到缓存组仲
    ///
    /// - Parameter index: 页签索引
    /// - Returns: 是否重新添加，true：重新添加，false：已经存在
    open func addViewCacheIndex(index: Int) -> Bool {
        
        var targetView: UIView?
        var flag = false
        
        //如果找不到缓存则重试初始化，并掺入
        if !self.viewsCache.keys.contains(index) {
            
            let item = self.slideItems[index]
            let obj = item.content.entity
            self.viewsCache[index] = obj
            switch obj {
            case let view as UIView:
                targetView = view
                self.rootScrollView.addSubview(view)
            case let vc as UIViewController:
                targetView = vc.view
                self.rootScrollView.addSubview(vc.view)
                if let parent = self.parent {
                    parent.addChildViewController(vc)
                }
            default:break
            }
            
            targetView?.frame = CGRect(x: CGFloat(index) * self.width, y: 0, width: self.width, height: self.height)
            
            //删除最远处的缓存对象
            if self.viewsCache.count > self.cacheSize {
                var removeIndex = index  - self.cacheSize
                //检查是否溢出
                if removeIndex < 0 {
                    removeIndex = index + self.cacheSize
                }
                
                self.removeViewCacheIndex(index: removeIndex)
                
            }
            
            flag = true
        } else {
            
            flag = false
        }
        

        return flag
    }
    
    
    /// 移除缓存组中View
    ///
    /// - Parameter index: 页签索引
    open func removeViewCacheIndex(index: Int) {
        let obj = self.viewsCache.removeValue(forKey: index)
        
        switch obj {
        case let view as UIView:
            view.removeFromSuperview()
        case let vc as UIViewController:
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        default:break
        }
    }
    
    
    
    /// 插入一个新的页面
    ///
    /// - Parameters:
    ///   - item: 新项
    ///   - index: 插入位置
    ///   - isSelected: 插入后是否显示当前页
    open func insertTab(item: CHSlideItem, at index: Int = -1, isSelected: Bool = false) {
        var insertIndex = index
        if index == -1 || index > self.slideItems.count {
            insertIndex = self.slideItems.endIndex
        }
        
        self.slideItems.insert(item, at: insertIndex)
        
        //缓存页面组，需要重新排列插入后的索引
        let endIndex = self.slideItems.count - 1
        for i in stride(from: endIndex - 1, through: insertIndex, by: -1) {
            if let tmp = self.viewsCache[i] {
                //右移进一
                self.viewsCache[i+1] = tmp
                //右移完成，移出当前位
                self.viewsCache.removeValue(forKey: i)
            }
            
        }
        

        //重新加载后执行，将新加入作为当前页显示
        self.layoutSubViewsCompletedBlock = {
            () -> Void in
            var animated = true, allowSame = false
            var moveToIndex: Int = insertIndex
            if isSelected {
                moveToIndex = insertIndex
                animated = true
            } else {
                animated = false
                //插入的大于当前，显示当前+1才能显示正确的页面
                if self.currentIndex >= insertIndex {
                    moveToIndex = self.currentIndex + 1

                } else {
                    moveToIndex = self.currentIndex

                }
                
            }
            
            //如果在当前位置中插入，不需要执行动画，允许重新选中就是
            if self.currentIndex == moveToIndex {
                animated = false
                allowSame = true
            } else {
                allowSame = false
            }
            
            
            self.updateCurrentIndex(index: moveToIndex, animated: animated, allowSame: allowSame)
            
        }
        
        //重新调整布局
        self.setNeedsLayout()

        
    }
    
    
    /// 更新当前位置
    ///
    /// - Parameters:
    ///   - index: 新位置
    ///   - animated: 是否执行动画
    ///   - allowSame: 是否允许更新相同位置也执行
    open func updateCurrentIndex(index: Int, animated: Bool = true, allowSame: Bool = false) {
        
        if index != self.currentIndex {
            
            if let vc = self.viewsCache[self.currentIndex] as? CHSlideSwitchSubViewDelegate {
                vc.subViewDidDisappear?(parent: self)
//                NSLog("\(vc) subViewDidDisappear")
            }
            if let vc = self.viewsCache[index] as? CHSlideSwitchSubViewDelegate {
                vc.subViewDidAppear?(parent: self)
//                NSLog("\(vc) subViewDidAppear")
            }
            
            self.currentIndex = index
        }
        
        self.headerView?.selectedTabView(at: self.currentIndex, animated: animated, allowSame: allowSame)
        
    }
}


// MARK: - 实现滚动委托方法
extension CHSlideSwitchView: UIScrollViewDelegate {
    
    
    @objc func scrollHandlePan(pan: UIPanGestureRecognizer) {

        //当滑道左边界时，传递滑动事件给代理
        if self.rootScrollView.contentOffset.x <= 0 {
            self.delegate?.slideSwitchView?(view: self, direction: true, panEdge: pan)
        } else if(self.rootScrollView.contentOffset.x >= self.rootScrollView.contentSize.width - self.rootScrollView.bounds.size.width) {
            self.delegate?.slideSwitchView?(view: self, direction: false, panEdge: pan)
        }
        
    }
    
    
    /// 代码执行滚动视图
    ///
    /// - Parameters:
    ///   - index: 位置
    ///   - animated:   是否执行动画
    public func setContentOffset(index: Int, animated: Bool, allowSame: Bool = false) {
        if self.showIndex >= 0 {
            let point = CGPoint(x: CGFloat(index) * self.rootScrollView.width, y: 0)
            self.setContentOffset(point, animated: animated, allowSame: allowSame)
        }
        
        //获取当前页面是否可以继续滑动
        let canScroll = self.delegate?.slideSwitchView?(view: self, canSwipeScroll: index) ?? true
        self.rootScrollView.isScrollEnabled = canScroll
    }
    
    
    /// 代码执行滚动视图
    ///
    /// - Parameters:
    ///   - contentOffset: 偏移坐标
    ///   - animated: 是否执行动画
    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool, allowSame: Bool = false) {
        self.rootScrollView.setContentOffset(contentOffset, animated: animated)
        let index = lround(Double(contentOffset.x / self.width))
        //计算偏移到哪一页
        self.updateCurrentIndex(index: index, allowSame: allowSame)
//        self.currentIndex = Int(contentOffset.x / self.width)
        self.showIndex = self.currentIndex
        _ = self.addViewCacheIndex(index: self.currentIndex)
        
    }
    
    
    /// 滑动开始
    ///
    /// - Parameter scrollView:
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //scrollView.isScrollEnabled = false
        self.startOffsetX = scrollView.contentOffset.x
        self.isPaning = true
    }
    
    
    /// 滑动过程回调
    ///
    /// - Parameter scrollView:
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard scrollView.isScrollEnabled else {
//            return
//        }
        guard let isSelectTab = self.headerView?.isSelectTab, isSelectTab || self.isPaning else  {
            return
        }
        let scale = self.rootScrollView.contentOffset.x / self.rootScrollView.contentSize.width
        self.headerView?.changePointScale(scale: scale)
    }
    
    
    /// 滑动后释放
    ///
    /// - Parameter scrollView:
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //计算偏移到哪一页
        let index = lround(Double(scrollView.contentOffset.x / self.width))
        self.updateCurrentIndex(index: index)
//        self.currentIndex = Int(scrollView.contentOffset.x / self.width)
        if self.loadViewTiming == .normal {
            _ = self.addViewCacheIndex(index: self.currentIndex)
        }
        self.headerView?.isSelectTab = false
        
        //获取当前页面是否可以继续滑动
        let canScroll = self.delegate?.slideSwitchView?(view: self, canSwipeScroll: self.currentIndex) ?? true
        scrollView.isScrollEnabled = canScroll
        
        self.isPaning = false
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.headerView?.isSelectTab = false
    }
}
