//
//  NetWorkHelper.swift
//  OneAPP
//
//  Created by 潘东 on 2017/5/22.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import Alamofire

/**
 NetWorkHelper 网络状态的帮助类
 提供app当前的网络状态
 */
class NetWorkHelper {
    /// Defines the various states of network reachability.
    ///
    /// - unknown:      It is unknown whether the network is reachable.
    /// - notReachable: The network is not reachable.
    /// - reachable:    The network is reachable.
    enum NetWorkReachableStatus {
        case notReachable
        case reachable(ConnectionType)
        case unknow
    }
    
    /// Defines the various connection types detected by reachability flags.
    ///
    /// - ethernetOrWiFi: The connection type is either over Ethernet or WiFi.
    /// - wwan:           The connection type is a WWAN connection.
    enum ConnectionType {
        case ethernetOrWiFi
        case wwan
    }
    
    /// A closure executed when the network reachability status changes. The closure takes a single argument: the
    /// network reachability status.
    public typealias ListenStatus = (NetWorkReachableStatus) -> Void
    
    // MARK: - Class Methods
    /**
     查询当前网络是否可用
     
     - Returns: True表示当前网络可用，否则返回false
     */
    public func isReachable() -> Bool {
        return manager!.isReachable
    }
    
    /**
     查询当前网络状态，**请仅在当前网络可用的情况是使用此方法检查网络连接状态**
     
     如需查询当前网络是否可用，请使用isReachable
     
     - Returns: .wwan表示使用运营商网络；.ethernetOrWiFi表示使用wifi或者线缆
     */
    public func networkStatus() -> NetWorkReachableStatus {
        return checkNetworkStatus()
    }
    
    // MARK: - Private Methods
    // 检查当前网络状态
    private func checkNetworkStatus() -> NetWorkReachableStatus {
        var currentStatus: NetWorkReachableStatus?
        
        if manager!.isReachableOnWWAN {
            currentStatus = NetWorkReachableStatus.reachable(.wwan)
        }
        
        if manager!.isReachableOnEthernetOrWiFi {
            currentStatus = NetWorkReachableStatus.reachable(.ethernetOrWiFi)
        }
        
        guard currentStatus != nil else {
            assertionFailure("Please Use 'isReachable' firstly to check current network is avaliable")
            return .notReachable
        }
        
        return currentStatus!
    }
    
    // MARK: - Init Method
    private init() { }
    static let sharedInstance = NetWorkHelper()
}
