//
//  ONServiceFactory.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/6.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

//TODO: 待重构为Swift风格
@objc protocol ONServiceFactoryDataSource: NSObjectProtocol {
    /**
     * key为service的id
     * value为service的Class的字符串
     *
     * 例如:
     
     let kOneApp = "kOneApp"
     extension AppDelegate: ONServiceFactoryDataSource {
         func servicesKindsOfServiceFactory() -> [String : String] {
            return [kOneApp: "OneAppService"]
        }
     }
     
     */
    @objc func servicesKindsOfServiceFactory() -> [String: String]
}

class ONServiceFactory {
    
    // MARK: - life cycle
    static let sharedInstance = ONServiceFactory()
    
    var serviceStorage = [String: ONService]()
    
    weak var dataSource: ONServiceFactoryDataSource?
    
    private init() { }
    
    // MARK: - public methods
    /// - parameter id: ServiceId
    ///
    /// - returns: 返回一个ONService，因为在这个方法内已经对异常情况进行那个了处理，所以返回的值可以直接强制解包
    func serviceWithId(_ id: String) -> ONService? {
        guard dataSource != nil else {
            assertionFailure("请给ONServiceFactory的dataSource赋值，建议在AppDelegate中实现")
            return nil
        }
        
        if serviceStorage[id] == nil {
            serviceStorage[id] = newServiceWithId(id)!
        }
        
        return serviceStorage[id]
    }
    
    // MARK: - private methods
    private func newServiceWithId(_ id: String) -> ONService? {
        guard (dataSource!.responds(to: #selector(dataSource!.servicesKindsOfServiceFactory))) else {
            assertionFailure("请实现ONServiceFactoryDataSource的servicesKindsOfServiceFactory方法，建议在AppDelegate中实现，并将ONServiceFactory的dataSource属性赋值为self")
            return nil
        }
        
        guard dataSource!.servicesKindsOfServiceFactory()[id] != nil else {
            assertionFailure("servicesKindsOfServiceFactory中无法找不到相匹配id")
            return nil
        }
        
        let classStr = dataSource!.servicesKindsOfServiceFactory()[id]
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let service = NSClassFromString(namespace + "." + classStr!) as? ONService.Type
        
        assert(service != nil, "无法创建service，请检查servicesKindsOfServiceFactory提供的数据是否正确")
        let relatedService = service!.init()
        
        return relatedService
    }
}
