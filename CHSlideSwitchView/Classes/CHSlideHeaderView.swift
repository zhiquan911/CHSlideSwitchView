//
//  CHSlideHeaderView.swift
//  Pods
//
//  Created by Chance on 2017/6/5.
//
//

import UIKit
import SnapKit

/// 选中滑块样式
///
/// - base: 基本
/// - line: 下划线
/// - arrow: 箭头
/// - rectangle: 矩形
/// - custom: 用户自定义View
public enum CHSlideSelectedViewStyle {
    case base
    case line(color: UIColor, height: CGFloat)
    case arrow(color: UIColor)
    //自定义圆角，颜色
    case rectangle(cornerRadius: CGFloat, height: CGFloat, color: UIColor)
    //自定义View
    case custom(view: UIView)
}


/// 选中滑块
open class CHSlideSelectedView: UIView {
    
    /// 下划线View
    open var viewLine: UIView?
    
    /// 矩形滑块
    open var viewRectangle: UIView?
    
    /// 箭头layer
    open var layerArrow: CAShapeLayer?
    
    
    /// 样式
    open var style: CHSlideSelectedViewStyle = .base
    
}


/// 顶部滚动标签的布局样式
///
/// - average: 平均宽度布局(最多显示数)
/// - center: 居中
/// - left: 左对齐
/// - right: 右对齐
public enum CHSlideHeaderViewLayout {
    
    case average(max: Int)
    case center
    case left
    case right
    
}
//重写相等处理
public func ==(lhs: CHSlideHeaderViewLayout, rhs: CHSlideHeaderViewLayout) -> Bool {
    switch (lhs,rhs) {
    case (.center,.center) : return true
    case (.left,.left) : return true
    case (.right,.right) : return true
    case let (.average(i), .average(j)) where i == j: return true
    default: return false
    }
}


open class CHSlideHeaderView: UIView {
    
    /// 内容元素组
    public var slideItems = [CHSlideItem]()
    
    /// 箭头高
    open var arrowHeight: CGFloat = 6
    
    /// 箭头宽
    open var arrowWidth: CGFloat = 18
    
    /// 滑动区域的padding
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 自定义背景
    open var backgroundImage: UIImage?
    
    /// tab的view实例
    open var viewTabs = [UIView]()
    
    /// 选中的视图风格
    open var selectedStyle: CHSlideSelectedViewStyle = .base
    
    /// 选中的视图，样式来自selectedStyle
    open var selectedView: UIView?
    
    /// 顶部滑动主视图
    open var tabScrollView: UIScrollView!
    
    /// 分割线
    open var viewBottomLine: UIView?
    
    /// 底边分割线高度
    open var viewBottomLineHeight: CGFloat = 0
    
    /// 底部分隔线颜色
    open var viewBottomLineColor: UIColor = UIColor.clear
    
    /// 当前选中的按钮，-1表示没有初始化
    open var currentIndex: Int = -1
    
    /// 右侧固定功能按钮
    open var viewAccessory: UIView?                     //右侧功能按钮
    
    /// 主视图
    open weak var slideSwitchView: CHSlideSwitchView?
    
    /// tab选中缩放比例
    open var selectedScale: CGFloat = 1.2
    
    /// tab字体默认大小
    open var fontSize: CGFloat = 14
    
    /// 动画时间
    open var animationTime: TimeInterval = 0.3
    
    /// 标签名字的内边距
    open var titlePading: CGFloat = 25
    
    //用来判断向左向右
    fileprivate var endScale: CGFloat = 0
    
    /// 标签布局样式，宽度足够大下最多显示的标签数
    open var layout: CHSlideHeaderViewLayout = .center
    
    /// 缓存一个标题宽度数组，因为文字一样，宽度一样，这样可以节省内存
    open var titlesWidthCache: [String: CGFloat] = [String: CGFloat]()
    
    /// 未选中颜色
    open var normalColor: UIColor = UIColor.lightGray
    
    /// 已选中颜色
    open var selectedColor: UIColor = UIColor.black
    
    /// 标签视图类型
    open var tabType: CHSlideTabType = .text
    
    /// 多功能视图宽度
    open var viewAccessoryWidth: CGFloat {
        return 0
    }
    
    /// 区分点击还是滑动
    open var isSelectTab: Bool = false
    
    /// 滚动视图的宽度
    open var scrollWidth: CGFloat {
        return self.width - self.viewAccessoryWidth
    }
    
    /// 滚动视图的高度
    open var scrollHeight: CGFloat {
        return self.height - self.viewBottomLineHeight
    }
    
    //MARK: - 初始化方法
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //如果你通过在XIB中设置初始化值，不要在这里做子视图的初始化，而是通过awakeFromNib
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.createUI()
    }
    
    
    /// 创建UI
    open func createUI() {
        
        self.tabScrollView = UIScrollView()
        self.addSubview(self.tabScrollView)
        
        if let more = self.viewAccessory {
            self.addSubview(more)
            //设置布局
            more.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(0)
                make.width.equalTo(self.viewAccessoryWidth)
                make.top.bottom.equalToSuperview().offset(0)
            }
        }
        
        //设置布局
        self.tabScrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(self.viewAccessoryWidth)
            make.top.bottom.equalToSuperview().offset(0)
        }
        
        self.tabScrollView.delegate = self
        self.tabScrollView.contentInset = self.padding
        self.tabScrollView.backgroundColor = UIColor.clear
        self.tabScrollView.isPagingEnabled = false
        self.tabScrollView.showsHorizontalScrollIndicator = false
        self.tabScrollView.showsVerticalScrollIndicator = false
        
        //添加选中的视图
        if self.selectedView != nil {
            self.tabScrollView.addSubview(self.selectedView!)
        }
        
    }
    
    /// 创建内容视图UI
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTabViews(tabViews: self.viewTabs)
        self.layoutSelectedView()
        
        //设置所有内容的宽度
        self.tabScrollView.contentSize = CGSize(width: max(self.scrollWidth, self.totalTabWidth), height: self.scrollHeight)
        
        //layout完成重置这个值
        self.isSelectTab = false
        
        self.changeTabContentOffset()
    }
    
    /// 重新加载tab
    open func reloadTabs() {
        let tabCount = self.slideItems.count
        
        // 【一】先清空所有滚动视图的子视图
        _ = self.viewTabs.map { $0.removeFromSuperview() }
        self.viewTabs.removeAll()
        
        // 【二】获取tab的item元素，如果是文字，有组件创建View，如果是自定义View，直接读取
        for i in 0..<tabCount {
            let item = self.slideItems[i]
            var tabView: UIView!
            switch self.tabType {
            case .text:
                tabView = self.createTabViews(with: item.title, color: self.normalColor, selectedColor: self.selectedColor)
            case .view:
                tabView = item.tabView!
            }
            
            //存到数组中
            tabView.tag = item.key
            self.viewTabs.append(tabView)
            self.tabScrollView.addSubview(tabView)
        }
        
        self.setNeedsLayout()
    }
    
    
    /// 配置选中视图的布局
    open func layoutSelectedView() {
        
        if self.currentIndex >= 0 {
            
            //添加选中视图
            if self.selectedView == nil {
                self.selectedView = self.createSelectedView()
                self.tabScrollView.addSubview(self.selectedView!)
                self.tabScrollView.sendSubview(toBack: self.selectedView!)
            }
            
            let view = self.viewTabs[self.currentIndex]
            view.transform = CGAffineTransform(scaleX: self.selectedScale, y: self.selectedScale)
            //处理选择View
            self.selectedView?.width = view.bounds.size.width
            self.selectedView?.centerX = view.centerX
        }
        
        
    }
    
    
    /// 计算并布局TabView
    ///
    /// - Parameters:
    ///   - tabViews:
    ///   - scrollView:
    open func layoutTabViews(tabViews: [UIView]) {
        
        //重置比例
        _ = tabViews.map { $0.transform = CGAffineTransform.identity }
        
        //判断总宽度是否超出最大滚动范围，超过了居中布局就没有意义，采用左对齐布局
        if self.totalTabWidth > self.scrollWidth && self.layout == .center {
            self.layout = .left
        }
        
        // 计算起始tab的布局起点
        var startX: CGFloat = self.padding.left
        
        if self.layout == .center {
            
            // 计算居中的起点
            startX = self.scrollWidth / 2
            
            for i in 0..<tabViews.count / 2 {
                startX = startX - self.getTabViewWidth(at: i)
            }
            
            //数组为奇数，中间的元素宽度减半
            if tabViews.count % 2 == 1 {
                startX = startX - self.getTabViewWidth(at: tabViews.count / 2) / 2
            }
            
        }
        
        // 布局所有tabview
        for (i, tab) in tabViews.enumerated() {
            
            tab.frame = CGRect(x: startX, y: 0,
                               width: self.getTabViewWidth(at: i),
                               height: self.scrollHeight)
            
            startX = startX + tab.bounds.size.width
            
        }
        
        
    }
    
    
    /// 创建选中的视图
    ///
    /// - Returns:
    open func createSelectedView() -> UIView {
        switch self.selectedStyle {
        case .base:
            return UIView() //透明空视图
        case let .line(color: color, height: height):
            let lineView = self.createLineView(color: color, height: height)
            return lineView
        case let .arrow(color: color):
            let lineView = self.createLineView(color: UIColor.clear, height: self.arrowHeight)
            let arrowLayer = self.createArrowLayer(color: color)
            lineView.backgroundColor = UIColor.clear
            arrowLayer.position = lineView.center
            lineView.layer.addSublayer(arrowLayer)
            
            return lineView
        case let .rectangle(cornerRadius: cornerRadius, height: height, color: color):
            let height = min(self.scrollHeight, height) //取最小的
            let slide = self.createSlideView(cornerRadius: cornerRadius, height: height, color: color)
            return slide
        case let .custom(view: view):
            return view
        }
    }
    
    
    /// 创建下划线
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - height: 高度
    /// - Returns:
    open func createLineView(color: UIColor, height: CGFloat) -> UIView {
        let width = self.getTabViewWidth(at: self.currentIndex)
        let lineView = UIView(frame: CGRect(x: 0, y: self.scrollHeight - height, width: width * self.selectedScale, height: height))
        lineView.backgroundColor = color
        return lineView
    }
    
    
    /// 创建箭头
    ///
    /// - Parameter color: 颜色
    /// - Returns: 箭头
    open func createArrowLayer(color: UIColor) -> CAShapeLayer {
        
        let arrowLayer = CAShapeLayer()
        arrowLayer.bounds = CGRect(x: 0, y: 0, width: self.arrowWidth, height: self.arrowHeight)
        arrowLayer.fillColor = color.cgColor
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: self.arrowWidth / 2, y: 0))
        arrowPath.addLine(to: CGPoint(x: arrowWidth, y: arrowHeight))
        arrowPath.addLine(to: CGPoint(x: 0, y: arrowHeight))
        arrowPath.close()
        arrowLayer.path = arrowPath.cgPath
        
        return arrowLayer
        
    }
    
    
    /// 创建滑块
    ///
    /// - Parameters:
    ///   - cornerRadius: 圆角
    ///   - color: 颜色
    /// - Returns:
    open func createSlideView(cornerRadius: CGFloat, height: CGFloat, color: UIColor) -> UIView {
        let width = self.getTabViewWidth(at: self.currentIndex)
        let slide = UIView(frame: CGRect(x: 0, y: (self.scrollHeight - height) / 2, width: width * self.selectedScale, height: height))
        slide.layer.cornerRadius = min(cornerRadius, height / 2)
        slide.clipsToBounds = true
        slide.backgroundColor = color
        
        return slide
    }
    
    /// tab上标题的总长度
    open var totalTabWidth: CGFloat {
        //reduce统计函数，初始0，$0累加和，$1计算对象
        let sumWidth: CGFloat = self.slideItems.reduce(0, {$0 + self.getTabViewWidth(for: $1)})
        return sumWidth + self.padding.left + self.padding.right
    }
    
    
    /// 获取TabView的宽度
    ///
    /// - Parameter index:
    /// - Returns:
    open func getTabViewWidth(at index: Int) -> CGFloat {
        let item = self.slideItems[index]
        return self.getTabViewWidth(for: item)
    }
    
    /// 获取tabview的宽度
    ///
    /// - Parameter index: 位置
    /// - Returns: 计算后的宽度
    open func getTabViewWidth(for item: CHSlideItem) -> CGFloat {
        
        var width: CGFloat = 0
        
        switch self.layout {
        case let .average(max):         //平均计算
            
            width = self.scrollWidth / CGFloat(max)
            
        default:
            
            switch self.tabType {           //动态计算
            case .text:
                width = self.getTitleWidth(text: item.title, padding: self.titlePading)
            case .view:
                width = item.tabView?.bounds.size.width ?? 0
            }
            
        }
        
        
        return width
    }
    
    
    /// 计算标签名字宽度
    ///
    /// - Parameter title: 标签名字
    /// - Returns: 宽度
    open func getTitleWidth(text : String, padding: CGFloat = 0) -> CGFloat {
        let font = UIFont.systemFont(ofSize: self.fontSize)
        //如果已经有缓存，直接返回计算过的宽度
        var textWidth: CGFloat = self.titlesWidthCache[text] ?? 0
        if textWidth > 0  {
            textWidth = textWidth + padding
        } else {
            
            //没有，再次生成
            let size = CGSize(width: CGFloat(MAXFLOAT), height: self.height)
            var textSize: CGSize!
            let newStr = NSString(string: text)
            if size.equalTo(CGSize.zero) {
                let attributes = [NSFontAttributeName: font]
                textSize = newStr.size(attributes: attributes)
            } else {
                let option = NSStringDrawingOptions.usesLineFragmentOrigin
                let attributes = [NSFontAttributeName: font]
                let stringRect = newStr.boundingRect(with: size, options: option, attributes: attributes, context: nil)
                textSize = stringRect.size
            }
            self.titlesWidthCache[text] = textSize.width
            
            textWidth = textSize.width + padding
        }

        return textWidth
    }
    
    
    /// 通过文本创建默认的tabView
    ///
    /// - Parameter title: 文本标题
    /// - Returns: tabView
    open func createTabViews(with title: String,
                             color: UIColor,
                             selectedColor: UIColor) -> UIView {
        
        
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: self.fontSize)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.addTarget(self, action: #selector(self.handleTabViewPress(sender:)),
                      for: .touchUpInside)
        
        return btn
    }
    
    
    /// 处理Tab按钮点击事件
    ///
    /// - Parameter tap:
    func handleTabViewPress(sender: AnyObject?) {
        var index: Int = -1
        switch sender {
        case let btn as UIButton:
            index = btn.tag
        case let tap as UITapGestureRecognizer:
            index = tap.view?.tag ?? -1
        default:break
            
        }
        
        // 执行点击TabView的过度处理
        self.selectedTabView(at: index)
        
    }
    
    
    /// 选中某个Tab
    ///
    /// - Parameter index: 索引位
    open func selectedTabView(at index: Int, animated: Bool = true, isLayout: Bool = false) {
        
        
        if index == self.currentIndex || index < 0 {
            
            return
        }
        
        //before
        let before = self.currentIndex;
        self.currentIndex = index;
        self.changeTabContentOffset()
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(self.animationTime)
        UIView.setAnimationsEnabled(animated)
        
        self.moveSelectedView(from: before, to: self.currentIndex)
        
        UIView.commitAnimations()
        
        self.isSelectTab = true
        
        //调整主视图内容
        self.slideSwitchView?.setContentOffset(index: index, animated: true)
        
        if self.slideSwitchView != nil {
            self.slideSwitchView?.delegate?.slideSwitchView?(view: self.slideSwitchView!, didSelected: self.currentIndex)
        }
        
    }
    
    
    /// 移动选中视图，从i到j
    ///
    /// - Parameters:
    ///   - from: 开始位置
    ///   - to: 结束位置
    open func moveSelectedView(from: Int, to: Int) {
        
        if from >= 0 {
            
            let fromView = self.viewTabs[from]
            
            switch self.tabType {
            case .text:
                let btn = fromView as! UIButton
                btn.setTitleColor(self.normalColor, for: .normal)
                btn.transform = CGAffineTransform.identity
                
            default:
                break
            }
        }
        
        
        
        if to >= 0 {
            
            let toView = self.viewTabs[to]
//            let tempWidth = toView.width
            switch self.tabType {
            case .text:
                let btn = toView as! UIButton
                btn.setTitleColor(self.selectedColor, for: .normal)
                btn.transform = CGAffineTransform(scaleX: self.selectedScale, y: self.selectedScale)
            default:
                break
            }
//            NSLog("tempWidth : toView.width = \(tempWidth) : \(toView.width)")
            
            //处理选择View
            self.selectedView?.width = toView.bounds.size.width
            self.selectedView?.centerX = toView.centerX
            
        }
        
    }
    
    
    /// 偏移Tab滚动视图，而呈现更多的内容
    ///
    func changeTabContentOffset() {
        
        if self.totalTabWidth > self.scrollWidth {
            let view = self.viewTabs[self.currentIndex]
            if view.centerX < self.scrollWidth / 2 {
                self.tabScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            } else if view.centerX > self.totalTabWidth - self.scrollWidth / 2 {
                self.tabScrollView.setContentOffset(CGPoint(x: self.totalTabWidth - self.scrollWidth, y: 0), animated: true)
            } else {
                self.tabScrollView.setContentOffset(CGPoint(x: view.centerX - self.scrollWidth / 2, y: 0), animated: true)
            }
        }
        
    }
    
    
    /// 处理滑动的过渡效果
    ///
    /// - Parameter scale: 主视图偏移的X位置 / 总宽度
    open func changePointScale(scale: CGFloat) {
        
        //如果是点击Tab操作被进行渐变过渡处理
        if self.isSelectTab {
            return
        }
        
        //防止溢出
        guard scale >= 0 else {
            return
        }
        
        //区分向左 还是向右
        let left = self.endScale > scale
        self.endScale = scale
        
        //每个view所占的百分比
        let perView: CGFloat = 1.0 / CGFloat(self.slideItems.count)
        
        //开始滑动的index
        let fromIndex: Int = Int(scale / perView) + (left ? 1 : 0)
        //下一个tab的index
        let toIndex: Int = fromIndex + (left ? -1 : 1)
        
        //防止溢出
        guard fromIndex < self.slideItems.count && toIndex < self.slideItems.count else {
            return
        }
        
        //获取tabView
        let fromView = self.viewTabs[fromIndex]
        let toView = self.viewTabs[toIndex]
        
        //计算开始时的宽度%
        var startScale: CGFloat = 0
        for i in 0..<toIndex {
            startScale = startScale + self.getTabViewWidth(at: i) / self.totalTabWidth
        }
        
        //滑动选中位置所占的相对百分比
        let currentTitleScale: CGFloat = self.getTabViewWidth(at: fromIndex) / self.totalTabWidth
        
        //单个view偏移的百分比
        let singleOffsetScale: CGFloat = (scale - perView * CGFloat(fromIndex)) / perView
        
        //转换成对应title的百分比
        let titleScale: CGFloat = singleOffsetScale * currentTitleScale + startScale
        
        //变化的百分比
        let changeScale: CGFloat = (left ? -1 : 1) * (titleScale - startScale) / currentTitleScale
        
        // 改变文字颜色
        if self.tabType == .text {
            let fromBtn = fromView as! UIButton
            let toBtn = toView as! UIButton
            self.colorChange(fromBtn: fromBtn, toBtn: toBtn, changeScale: changeScale)
            
        }
        
        // 改变视图大小
        self.tabViewChange(fromView: fromView, toView: toView, changeScale: changeScale)
        
        // 改变选中层视图大小
        self.selectedView?.width = self.widthChange(
            fromWidth: self.getTabViewWidth(at: fromIndex),
            toWidth: self.getTabViewWidth(at: toIndex),
            changeScale: changeScale, endScale: 1)
        self.selectedView?.centerX = self.centerChange(
            fromView: fromView,
            toView: toView,
            changeScale: changeScale)
        
        
    }
    
    
    /// 处理两个长度之间的过渡变化
    ///
    /// - Parameters:
    ///   - fromWidth: 开始的宽度
    ///   - toWidth: 最终的宽度
    ///   - changeScale: 变化比例
    ///   - endScale: 最后的比例
    /// - Returns: 新的宽度
    func widthChange(fromWidth: CGFloat, toWidth: CGFloat, changeScale: CGFloat, endScale: CGFloat) -> CGFloat {
        //改变的宽度
        let change = fromWidth - toWidth
        //宽度变化
        let width = fromWidth * endScale - changeScale * change
        return width
    }
    
    
    /// 改变按钮文字颜色
    ///
    /// - Parameters:
    ///   - fromBtn: 从按钮
    ///   - toBtn: 到按钮
    ///   - changeScale: 渐变量
    func colorChange(fromBtn: UIButton,toBtn: UIButton, changeScale: CGFloat) {
        
        var n_r: CGFloat = 0
        var n_g: CGFloat = 0
        var n_b: CGFloat = 0
        var n_a: CGFloat = 0
        
        guard self.normalColor.getRed(&n_r, green: &n_g, blue: &n_b, alpha: &n_a) else {
            return
        }
        
        var s_r: CGFloat = 0
        var s_g: CGFloat = 0
        var s_b: CGFloat = 0
        var s_a: CGFloat = 0
        
        guard self.selectedColor.getRed(&s_r, green: &s_g, blue: &s_b, alpha: &s_a) else {
            return
        }
        
        let c_r = s_r - n_r
        let c_g = s_g - n_g
        let c_b = s_b - n_b
        let c_a = s_a - n_a
        
        toBtn.setTitleColor(
            UIColor(
                red: n_r + c_r * changeScale,
                green: n_g + c_g * changeScale,
                blue: n_b + c_b * changeScale,
                alpha: n_a + c_a * changeScale
            ),
            for: .normal)
        
        fromBtn.setTitleColor(
            UIColor(
                red: s_r - c_r * changeScale,
                green: s_g - c_g * changeScale,
                blue: s_b - c_b * changeScale,
                alpha: s_a - c_a * changeScale
            ),
            for: .normal)
        
       
    }
    
    
    /// 中心位置的变化
    ///
    /// - Parameters:
    ///   - fromView: 开始移动的view
    ///   - toView: 目标移动到的view
    ///   - changeScale:
    /// - Returns:
    func centerChange(fromView: UIView, toView: UIView, changeScale: CGFloat) -> CGFloat {
        //lineView改变的中心
        let changeCenter: CGFloat = toView.centerX - fromView.centerX
        //lineView位置变化
        let centerX: CGFloat = fromView.center.x + changeScale * changeCenter;
        return centerX
    }
    
    
    func tabViewChange(fromView: UIView, toView: UIView, changeScale: CGFloat) {
        
        //改变字体大小
        let deltaScale = self.selectedScale - 1.0
        fromView.transform = CGAffineTransform(scaleX: self.selectedScale - deltaScale * changeScale, y: self.selectedScale - deltaScale * changeScale)
        toView.transform =  CGAffineTransform(scaleX: 1.0 + deltaScale * changeScale, y: 1.0 + deltaScale * changeScale)
        
    }
    
    
    /// 更新TabView内容
    ///
    /// - Parameters:
    ///   - index: 索引位
    ///   - block: 返回一个视图给调用者
    open func updateTab(at index: Int, block: (_ view: UIView, _ item: CHSlideItem) -> CHSlideItem) {
        
        //防止越界
        guard index < self.viewTabs.count else {
            return
        }
        
        let tabView = self.viewTabs[index]
        let item = self.slideItems[index]
        let newItem = block(tabView, item)
        self.slideItems[index] = newItem
    }
}


extension CHSlideHeaderView: UIScrollViewDelegate {
    
    
    
}
