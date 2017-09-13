//
//  IntHelper.swift
//  ONExtensionInt
//
//  Created by 潘东 on 2017/5/16.
//  Copyright © 2017年 com.onenet.app. All rights reserved.
//

import Foundation

// MARK: - Common
extension Date {
    /// Initializes Date from string and format
    public init?(fromString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    
    /// 13位时间戳的初始化
    public init?(fromLongTimeInterval longTimeInterval: Double) {
        self = Date.init(timeIntervalSince1970: longTimeInterval / 1000 )
    }
    /**
     今日发布显示‘’**:**’’
     
     昨日发布显示‘’昨天’’
     
     非今日和昨日发布显示‘’**-**-**’’
     */
    public func timeString() -> String {
        if isToday {
            return todayTimeStr
        } else if isYesterday {
            return "昨天"
        } else {
            return normalDayTimeStr
        }
    }
    // Check date if it is today
    public var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check date if it is yesterday
    public var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Get the weekday from the date
    public var weekday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    /// 是否是今年
    private var isYear: Bool {
        let today = Date()
        return self.year == today.year
    }
    
    /// Check date if it is within this month.
    public var isThisMonth: Bool {
        let today = Date()
        return self.month == today.month && self.year == today.year
    }

    
    // Get the month from the date
    public var monthAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    // 'yyyy/MM/dd'类型
    public var normalDayTimeStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
    
    // 'HH:mm'类型
    public var todayTimeStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    /// Get the year from the date
    public var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
    
    /// Get the month from the date
    public var month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    
    // Get the day from the date
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// Get the hours from date
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    
    /// Get the minute from date
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    /// Get the second from the date
    public var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    /// Gets the nano second from the date
    public var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
}
