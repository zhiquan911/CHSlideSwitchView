//: Playground - noun: a place where people can play

import UIKit

var cacheSize: Int = 5
var viewsCache = [Int: String]()

/// 添加视图到
///
/// - Parameter index:
func updateViewCacheIndex(index: Int, value: String) {
    
    //如果找不到缓存则重试初始化，并掺入
    if !viewsCache.keys.contains(index) {
        
        viewsCache[index] = value
        
        //删除最远处的缓存对象
        if viewsCache.count > cacheSize {
            var removeIndex = index  - cacheSize
            //检查是否溢出
            if removeIndex < 0 {
                removeIndex = index + cacheSize
            }
            
            viewsCache.removeValue(forKey: removeIndex)
            
        }
        
    }
    
    print(viewsCache)
    
}

updateViewCacheIndex(index: 0, value: "0")
updateViewCacheIndex(index: 1, value: "1")
updateViewCacheIndex(index: 2, value: "2")
updateViewCacheIndex(index: 3, value: "3")
updateViewCacheIndex(index: 4, value: "4")
updateViewCacheIndex(index: 5, value: "5")
updateViewCacheIndex(index: 6, value: "6")
updateViewCacheIndex(index: 5, value: "5")
updateViewCacheIndex(index: 4, value: "4")
updateViewCacheIndex(index: 3, value: "3")
updateViewCacheIndex(index: 2, value: "2")
updateViewCacheIndex(index: 1, value: "1")
updateViewCacheIndex(index: 0, value: "0")