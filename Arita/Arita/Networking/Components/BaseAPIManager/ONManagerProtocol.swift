//
//  ONManagerProtocol.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/6.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

//MARK: - ONAPIManagerApiCallBackDelegate

/***************************************************************************************************/
/*                               ONAPIManagerApiCallBackDelegate                                   */
/***************************************************************************************************/

// API 回调
protocol ONAPIManagerCallBackDelegate: class {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager)
    func managerCallAPIDidFailed(manager: ONAPIBaseManager)
}


//MARK: - ONAPIManagerCallbackDataReformer

/***************************************************************************************************/
/*                               ONAPIManagerCallbackDataReformer                                  */
/***************************************************************************************************/

//负责重新组装API数据的对象
protocol ONAPIManagerDataReformer {
    /*
     比如同样的一个获取电话号码的逻辑，二手房，新房，租房调用的API不同，所以它们的manager和data都会不同。
     即便如此，同一类业务逻辑（都是获取电话号码）还是应该写到一个reformer里面去的。这样后人定位业务逻辑相关代码的时候就非常方便了。
     
     代码样例：
     - (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)data
     {
     if ([manager isKindOfClass:[xinfangManager class]]) {
     return [self xinfangPhoneNumberWithData:data];      //这是调用了派生后reformer子类自己实现的函数，别忘了reformer自己也是一个对象呀。
     //reformer也可以有自己的属性，当进行业务逻辑需要一些外部的辅助数据的时候，
     //外部使用者可以在使用reformer之前给reformer设置好属性，使得进行业务逻辑时，
     //reformer能够用得上必需的辅助数据。
     }
     
     if ([manager isKindOfClass:[zufangManager class]]) {
     return [self zufangPhoneNumberWithData:data];
     }
     
     if ([manager isKindOfClass:[ershoufangManager class]]) {
     return [self ershoufangPhoneNumberWithData:data];
     }
     }
     */
    func manager(_ manager: ONAPIBaseManager, reformData data: Data) -> Any
}


//MARK: - ONAPIManagerValidator

/***************************************************************************************************/
/*                                     ONAPIManagerValidator                                       */
/***************************************************************************************************/

//验证器，用于验证调用API的参数或者API的返回是否正确
/*
 使用场景：
 当我们确认一个api是否真正调用成功时，要看的不光是status，还有具体的数据内容是否为空。由于每个api中的内容对应的key都不一定一样，甚至于其数据结构也不一定一样，因此对每一个api的返回数据做判断是必要的，但又是难以组织的。
 为了解决这个问题，manager有一个自己的validator来做这些事情，一般情况下，manager的validator可以就是manager自身。
 
 1.有的时候可能多个api返回的数据内容的格式是一样的，那么他们就可以共用一个validator。
 2.有的时候api有修改，并导致了返回数据的改变。在以前要针对这个改变的数据来做验证，是需要在每一个接收api回调的地方都修改一下的。但是现在就可以只要在一个地方修改判断逻辑就可以了。
 3.有一种情况是manager调用api时使用的参数不一定是明文传递的，有可能是从某个变量或者跨越了好多层的对象中来获得参数，那么在调用api的最后一关会有一个参数验证，当参数不对时不访问api，同时自身的errorType将会变为CTAPIManagerErrorTypeParamsError。这个机制可以优化我们的app。
 
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 */
protocol ONAPIManagerValidator: class {
    /*
     
     “
     william补充（2013-12-6）：
     4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
     ”
     
     所以不要以为这个params验证不重要。当调用API的参数是来自用户输入的时候，验证是很必要的。
     当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
     不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
     
     */
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool
    
    /*
     所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
     因为判断逻辑都在这里做掉了。
     而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
     */
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool
}

extension ONAPIManagerValidator {
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool {
        return true
    }
}


//MARK: - ONAPIManagerParamSourceDelegate

/***************************************************************************************************/
/*                                ONAPIManagerParamSourceDelegate                                  */
/***************************************************************************************************/

//让manager能够获取调用API所需要的数据
protocol ONAPIManagerParamSource: class {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData
}


//MARK: - 常量／状态／类型 枚举类型

/*************************************************************************************************/
/*                                      常量／状态／类型 枚举类型                                    */
/*************************************************************************************************/

let kONAPIBaseManagerRequestID = "ONAPIBaseManagerRequestID"

enum ONAPIManagerRequestType: Int {
    
    case get = 0
    case post
    case put
    case delete
}

enum ONAPIManagerErrorType: Int {
    ///没有产生过API请求，这个是manager的默认状态。
    case defaultStatus = 0
    ///API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    case success
    ///API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    case noContent
    ///参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    case paramsError
    ///请求超时。ONAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看ONNetworkingConfigurationManager的相关代码。
    case timeout
    ///网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    case noNetWork
    ///没有更多数据
    case noMoreData
}

typealias ONParamData = [String: Any]


//MARK: - ONAPIManager

/***************************************************************************************************/
/*                                         ONAPIManager                                            */
/***************************************************************************************************/

// ONAPIBaseManager的派生类必须符合这些protocal
protocol ONAPIManager: class {
    // Required
    func methodName() -> String
    func serviceType() -> String
    func requestType() -> ONAPIManagerRequestType
    
    // Optional
    // used for pagable API Managers mainly
    var shouldLoadFromNative: Bool { get }
}

// 扩展protocol为了默认实现，完成方法optional的功能。若协议实现者未实现这些方法，则会进入默认方法的实现。
extension ONAPIManager {
    var shouldLoadFromNative: Bool {
        return false
    }
}


//MARK: - ONAPIManagerInterceptor

/*************************************************************************************************/
/*                                    ONAPIManagerInterceptor                                    */
/*************************************************************************************************/
/*
 ONAPIBaseManager的派生类必须符合这些protocal
 */
protocol ONAPIManagerInterceptor: class {
    // Optional
    func manager(_ manager: ONAPIBaseManager, beforePerformSuccessWithResponse response: ONURLResponse) -> Bool
    func manager(_ manager: ONAPIBaseManager, afterPerformSuccessWithResponse response: ONURLResponse)
    
    func manager(_ manager: ONAPIBaseManager, beforePerformFailWithResponse response: ONURLResponse) -> Bool
    func manager(_ manager: ONAPIBaseManager, afterPerformFailWithResponse response: ONURLResponse)
    
    func manager(_ manager: ONAPIBaseManager, shouldCallAPIWithParams params: ONParamData) -> Bool
    func manager(_ manager: ONAPIBaseManager, afterCallingAPIWithParams params: ONParamData)
}

// 扩展protocol为了默认实现，完成方法optional的功能。若协议实现者未实现这些方法，则会进入默认方法的实现。
extension ONAPIManagerInterceptor {
    func manager(_ manager: ONAPIBaseManager, beforePerformSuccessWithResponse response: ONURLResponse) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, afterPerformSuccessWithResponse response: ONURLResponse) {
        // Do Nothing For Default Implemention
    }
    
    func manager(_ manager: ONAPIBaseManager, beforePerformFailWithResponse response: ONURLResponse) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, afterPerformFailWithResponse response: ONURLResponse) {
        // Do Nothing For Default Implemention
    }
    
    func manager(_ manager: ONAPIBaseManager, shouldCallAPIWithParams params: ONParamData) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, afterCallingAPIWithParams params: ONParamData) {
        // Do Nothing For Default Implemention
    }
}
