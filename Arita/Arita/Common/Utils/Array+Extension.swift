//
//  Array+Extension.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/16.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

// 获取正确的删除索引
func getRemoveIndex<T: Equatable>(value: T, array: [T]) -> [Int]{
    
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    
    // 获取指定值在数组中的索引
    for (index, _) in array.enumerated() {
        if array[index] == value {
            indexArray.append(index)
        }
    }
    
    // 计算正确的删除索引
    for (index, originIndex) in indexArray.enumerated() {
        // 指定值索引减去索引数组的索引
        let correctIndex = originIndex - index
        
        // 添加到正确的索引数组中
        correctArray.append(correctIndex)
    }
    
    return correctArray
}


/// 从数组中删除指定元素
public func removeValueFromArray<T: Equatable>(value: T, array: inout [T]){
    
    let correctArray = getRemoveIndex(value: value, array: array)
    
    // 从原数组中删除指定元素
    for index in correctArray{
        array.remove(at: index)
    }
    
}
