//
//  ONAPIBaseManager.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/6.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

class ONAPIBaseManager {
    
    // 由负责调用API接口的业务Controller实现
    weak var delegate: ONAPIManagerCallBackDelegate?
    weak var paramSource: ONAPIManagerParamSource?
    
    // 由SubAPIManager来实现
    weak var validator: ONAPIManagerValidator?
    private weak var child: ONAPIManager?
    weak var interceptor: ONAPIManagerInterceptor?
    
    var errorMessage: String?
    var errorType: ONAPIManagerErrorType
    var response: ONURLResponse?
    
    private(set) var isLoading: Bool
    private var isNativeDataEmpty = true
    
    private var fetchedRawData = Data()
    private var requestIdList = [Int]()
    private var cache = ONCache.sharedInstance
    
    init() {
        delegate = nil
        paramSource = nil
        validator = nil
        interceptor = nil
        
        isLoading = false
        
        errorMessage = nil
        errorType = .defaultStatus
        response = nil
        
        if let aChild = self as? ONAPIManager {
            child = aChild
        } else {
            assertionFailure("子类没有遵循ONAPIManager协议")
        }
    }
    
    deinit {
        cancelAllRequests()
        requestIdList = []
    }
    
    //MARK: - public methods
    public func cancelAllRequests() {
        ONApiProxy.sharedInstance.cancelRequestWithRequestIdList(requestIdList)
        requestIdList.removeAll()
    }
    
    public func cancelRequestWithRequestId(requestId: Int) {
        if removeRequestIdWithRequestId(requestId) {
            ONApiProxy.sharedInstance.cancelRequestWithRequestId(requestId)
        }
    }
    
    public func fetchDataWithReformer(_ reformer: ONAPIManagerDataReformer?) -> Any {
        var resultData: Any
        
        if let myReformer = reformer {
            resultData = myReformer.manager(self, reformData: fetchedRawData) as Any
        } else {
            resultData = fetchedRawData as Any
        }
        
        return resultData
    }
    
    //MARK: - calling api
    @discardableResult public func loadData() -> Int {
        assert(paramSource != nil, "APIManager的派生类的实例未设置paramSource")
        let params = paramSource!.paramsForApi(manager: self)
        let requestId = loadDataWithParams(params: params)
        
        return requestId
    }
    
    private func loadDataWithParams(params: ONParamData) -> Int {
        var requestId = 0
        
        let apiParams = reformParams(params)
        if shouldCallAPIWithParams(apiParams) {
            
            assert(validator != nil, "APIManager的派生类未设置validator")
            
            if validator!.manager(self, isCorrectWithParamsData: apiParams) {
                
                if child!.shouldLoadFromNative {
                    loadDataFromNative()
                }
                
                // 先检查一下是否有缓存
                if shouldCache() && hasCacheWithParams(apiParams) {
                    return 0
                }
                
                // 实际的网络请求
                if isReachable {
                    isLoading = true
                    switch child!.requestType() {
                    case .get:
                        requestId = callAPI(requeseType: .get, withParam: apiParams)
                        
                    case .post:
                        requestId = callAPI(requeseType: .post, withParam: apiParams)
                        
                    case .put:
                        requestId = callAPI(requeseType: .put, withParam: apiParams)
                        
                    case .delete:
                        requestId = callAPI(requeseType: .delete, withParam: apiParams)
                    }
                    
                    var params = apiParams
                    params[kONAPIBaseManagerRequestID] = requestId
                    afterCallingAPIWithParams(params)
                    
                    return requestId
                } else {
                    failedOnCallingApi(response: nil, withErrorType: .noNetWork)
                    
                    return requestId
                }
            } else {
                failedOnCallingApi(response: nil, withErrorType: .paramsError)
                
                return requestId
            }
        }
        return requestId
    }
    
    //MARK: - api callbacks
    private func successedOnCallingApi(response: ONURLResponse) {
        isLoading = false
        self.response = response
        
        if child!.shouldLoadFromNative {
            if response.isCached == false {
                UserDefaults.standard.set(response.responseData, forKey: child!.methodName())
                UserDefaults.standard.synchronize()
            }
        }
        
        fetchedRawData = response.responseData
        removeRequestIdWithRequestId(response.requestId)
        
        if validator!.manager(self, isCorrectWithCallBackData: response.responseData) {
            
            if shouldCache() && !response.isCached {
                // 这里直接使用response.requestParams!是因为此处缓存的是网络上来的response，如果是init(withData data: Data)初始化方法得到的response，此时isCached为True，也就不会执行到这里了
                cache.saveCacheWithData(response.responseData, serviceIdentifier: child!.serviceType(), methodName: child!.methodName(), requestParams: response.requestParams)
            }
            
            if beforePerformSuccessWithResponse(response) {
                
                if child!.shouldLoadFromNative {
                    if response.isCached {
                        delegate!.managerCallAPIDidSuccess(manager: self)
                    }
                    
                    if isNativeDataEmpty {
                        delegate!.managerCallAPIDidSuccess(manager: self)
                    }
                } else {
                    delegate!.managerCallAPIDidSuccess(manager: self)
                }
            }
            afterPerformSuccessWithResponse(response)
        } else {
            failedOnCallingApi(response: response, withErrorType: ONAPIManagerErrorType.noContent)
        }
    }
    
    private func failedOnCallingApi(response: ONURLResponse?, withErrorType errorType: ONAPIManagerErrorType) {
        let serviceId = child!.serviceType()
        let service = ONServiceFactory.sharedInstance.serviceWithId(serviceId)
        
        isLoading = false
        self.response = response
        
        var needCallBack = true
        
        if let childService = service?.child {
            needCallBack = childService.shouldCallBackByFailedOnCallingAPI(response)
        }
        
        //由service决定是否结束回调
        if !needCallBack {
           return
        }
        
        //继续错误的处理
        self.errorType = errorType
        if let hasResponse = response {
            removeRequestIdWithRequestId(hasResponse.requestId)
            if beforePerformFailWithResponse(hasResponse) {
                delegate?.managerCallAPIDidFailed(manager: self)
            }
            afterPerformFailWithResponse(hasResponse)
        } else {
            self.errorType = .noContent
            delegate?.managerCallAPIDidFailed(manager: self)
        }
    }
    
    //MARK: - method for interceptor
    /*
     拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
     当两种情况共存的时候，子类重载的方法一定要调用一下super
     然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
     
     notes:
     正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
     但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
     所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
     这就是decorate pattern
     */
    /// 会在执行代理方法managerCallAPIDidSuccess方法之前执行
    ///
    /// - parameter response: 网络请求的response
    public func beforePerformSuccessWithResponse(_ response: ONURLResponse) -> Bool {
        if interceptor != nil {
            return interceptor!.manager(self, beforePerformSuccessWithResponse: response)
        }
        
        return true
    }
    
    /// 会在执行代理方法managerCallAPIDidSuccess方法之后执行
    ///
    /// - parameter response: 网络请求的response
    public func afterPerformSuccessWithResponse(_ response: ONURLResponse) {
        if interceptor != nil {
            interceptor!.manager(self, afterPerformSuccessWithResponse: response)
        }
    }
    
    /// 会在执行代理方法managerCallAPIDidFailed方法之前执行
    ///
    /// - parameter response: 网络请求的response
    public func beforePerformFailWithResponse(_ response: ONURLResponse) -> Bool {
        if interceptor != nil {
            return interceptor!.manager(self, beforePerformFailWithResponse: response)
        }
        return true
    }
    
    /// 会在执行代理方法managerCallAPIDidFailed方法之后执行
    ///
    /// - parameter response: 网络请求的response
    public func afterPerformFailWithResponse(_ response: ONURLResponse) {
        if interceptor != nil {
            interceptor!.manager(self, afterPerformFailWithResponse: response)
        }
    }
    
    //只有返回YES才会继续调用API
    public func shouldCallAPIWithParams(_ params: ONParamData) -> Bool {
        if interceptor != nil {
            return interceptor!.manager(self, shouldCallAPIWithParams: params)
        }
        
        return true
    }
    
    /// 会在请求API完成之后执行
    ///
    /// **注意:** 这个拦截方法会在最后执行其他四个拦截器方法之后执行，所以执行此方法之前可能已经执行了别的拦截器方法。
    /// - parameter params: 请求的参数，可根据kONAPIBaseManagerRequestID字段来获取当前的requestId
    public func afterCallingAPIWithParams(_ params: ONParamData) {
        if interceptor != nil {
            interceptor!.manager(self, afterCallingAPIWithParams: params)
        }
    }
    
    
    //MARK: - method for child
    //如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
    //子类中覆盖这个函数的时候就不需要调用super.reformParams了
    public func reformParams(_ params: ONParamData) -> ONParamData {
        return params
    }
    
    public func cleanData() {
        cache.clean()
        fetchedRawData = Data()
        errorMessage = nil
        errorType = .defaultStatus
    }
    
    //MARK: - private methods
    @discardableResult private func removeRequestIdWithRequestId(_ requestId: Int) -> Bool {
        var isRemoved = false
        
        var idToRemove: Int?
        for id in requestIdList  {
            if id == requestId {
                idToRemove = id
            }
        }
        if let rmId = idToRemove {
            removeValueFromArray(value: rmId, array: &requestIdList)
            isRemoved = true
        }
        
        return isRemoved
    }
    
    private func callAPI(requeseType: ONAPIManagerRequestType, withParam apiParam: ONParamData) -> Int {
        var requestId = 0
        switch requeseType {
            
        case .get:
            requestId = ONApiProxy.sharedInstance.callGETWithParams(
                params: apiParam,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.successedOnCallingApi(response: response)
                },
                fail: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.errorMessage = response.error?.localizedDescription
                    strongSelf.failedOnCallingApi(response: response, withErrorType: .noContent)
            })
            
        case .post:
            requestId = ONApiProxy.sharedInstance.callPOSTWithParams(
                params: apiParam,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.successedOnCallingApi(response: response)
                },
                fail: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.errorMessage = response.error?.localizedDescription
                    strongSelf.failedOnCallingApi(response: response, withErrorType: .noContent)
            })
            
        case .put:
            requestId = ONApiProxy.sharedInstance.callPUTWithParams(
                params: apiParam,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.successedOnCallingApi(response: response)
                },
                fail: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.errorMessage = response.error?.localizedDescription
                    strongSelf.failedOnCallingApi(response: response, withErrorType: .noContent)
            })
            
        case .delete:
            requestId = ONApiProxy.sharedInstance.callDELETEWithParams(
                params: apiParam,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.successedOnCallingApi(response: response)
                },
                fail: { [weak self]
                    response in
                    guard let strongSelf = self else { return }
                    strongSelf.errorMessage = response.error?.localizedDescription
                    strongSelf.failedOnCallingApi(response: response, withErrorType: .noContent)
            })
        }
        requestIdList.append(requestId)
        
        return requestId
    }
    
    //MARK: - For Cache
    public func shouldCache() -> Bool {
        return ONNetworkingConfigurationManager.sharedInstance.shouldCache
    }
    
    private func hasCacheWithParams(_ params: ONParamData) -> Bool {
        let serviceId = child!.serviceType()
        let methodName = child!.methodName()
        let result = cache.fetchCachedDataWithServiceIdentifier(serviceId, methodName: methodName, requestParams: params)
        if let resultData = result {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let response = ONURLResponse(withData: resultData)
                response.requestParams = params
                ONLogger.logDebugInfoWithCachedResponse(response, methodName: methodName, serviceIdentifier: ONServiceFactory.sharedInstance.serviceWithId(serviceId))
                strongSelf.successedOnCallingApi(response: response)
            }
            return true
        } else {
          return false
        }
    }
    
    // 通过MethodName来缓存相应的数据，然后直接通过MethodName来获取数据
    private func loadDataFromNative() {
        let methodName = child!.methodName()
        let result = UserDefaults.standard.data(forKey: methodName)
        
        if let resultData = result {
            isNativeDataEmpty = false
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let response = ONURLResponse(withData: resultData)
                strongSelf.successedOnCallingApi(response: response)
            }
        } else {
            isNativeDataEmpty = true
        }
    }
    
    //MARK: - getters and setters
    var isReachable: Bool {
        get {
            let isReachability = ONNetworkingConfigurationManager.sharedInstance.isReachable
            if !isReachability! {
                errorType = ONAPIManagerErrorType.noNetWork
            }
            return isReachability!
        }
    }
}
