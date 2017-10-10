//
//  TataArticleModel.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation

/**
 TataArticleModel **文章列表**页主页的塔塔报的数据模型
 */
struct TataArticleModel {
    public var tataDate: String?
    public var tataPic: String?
    public var tataTitle: String?
    public var tataContent: String?
    
    //TODO: - 后期删除
    public static func demoModel() -> [TataArticleModel] {
        return [TataArticleModel(tataDate: "TUESDAY, MAR.19", tataPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505393598169&di=5b7bc88e0dc4e74721e868bd0fd8b03b&imgtype=0&src=http%3A%2F%2Fimg.weixinyidu.com%2F150921%2Ff9718e53.jpg", tataTitle: "英国有一个最佳设计效率奖，今年颁给了一款“胶水”", tataContent: "不管一款产品在设计、研发阶段经历了怎样的反复测试、精心打磨、耗费了多少人力物力，它总要一点或者简单或者隆重的仪式感，以合适的姿态亮相。"),
                TataArticleModel(tataDate: "TUESDAY, MAR.18", tataPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506049096&di=fe3aad8046acf9612b51dc81365f820b&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.enterdesk.com%2F2015%2Flcx%2F1%2F26%2F7%2F3.jpg", tataTitle: "无人驾驶汽车的“智商”还不如马车，这个风口对消费者来说还有点早", tataContent: "不管一款产品在设计、研发阶段经历了怎样的反复测试、精心打磨、耗费了多少人力物力，它总要一点或者简单或者隆重的仪式感，以合适的姿态亮相。"),
                TataArticleModel(tataDate: "TUESDAY, MAR.17", tataPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506320745&di=eefe996461f058b484cdebb05375f00b&imgtype=jpg&er=1&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D22889bfbf8d3572c72ef949fe27a0952%2F10dfa9ec8a1363274a890e219b8fa0ec08fac7b8.jpg", tataTitle: "如何用最少的钱在逼仄的环境里搭建一个家庭影院", tataContent: "不管一款产品在设计、研发阶段经历了怎样的反复测试、精心打磨、耗费了多少人力物力，它总要一点或者简单或者隆重的仪式感，以合适的姿态亮相。"),
                TataArticleModel(tataDate: "TUESDAY, MAR.16", tataPic: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505725706821&di=ac7ddf53163051d45152e2f553dc1f52&imgtype=0&src=http%3A%2F%2Ffile.wisetravel.cn%2Forigin_b%2F36f8dac7a54548a8bdaf5e317c1190fed32b59b3.jpeg%3Fv1.93", tataTitle: "中超、NBA 都要变成短视频了，今日头条和微博们会把体育比赛带到哪里？", tataContent: "不管一款产品在设计、研发阶段经历了怎样的反复测试、精心打磨、耗费了多少人力物力，它总要一点或者简单或者隆重的仪式感，以合适的姿态亮相。"),
                TataArticleModel(tataDate: "TUESDAY, MAR.15", tataPic: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1664351629,3380366627&fm=27&gp=0.jpg", tataTitle: "英国有一个最佳设计效率奖，今年颁给了一款“胶水”", tataContent: "不管一款产品在设计、研发阶段经历了怎样的反复测试、精心打磨、耗费了多少人力物力，它总要一点或者简单或者隆重的仪式感，以合适的姿态亮相。")
        ]
    }
    
    public static func initial() -> TataArticleModel {
        return TataArticleModel(tataDate: nil, tataPic: nil, tataTitle: nil, tataContent: nil)
    }
}
