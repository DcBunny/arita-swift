//
//  ArticleHomeController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import MJRefresh

/**
 ArticleHomeController **文章**页主页
 */
class ArticleHomeController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .custom)
        setNavi(leftIcon: UIImage(named: Icon.topCalendar)!, leftAction: #selector(gotoCalendar), rightIcon: UIImage(named: Icon.topMine)!, rightAction: #selector(gotoMine))
        let titleView = UIImageView(image: UIImage(named: Icon.topTitleLogo))
        setTitleView(titleView)
    }
    
    private func addPageViews() {
        view.addSubview(tableView)
        view.addSubview(categoryButton)
    }
    
    private func layoutPageViews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        categoryButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.bottom.equalTo(view).offset(-15)
        }
    }
    
    private func setPageViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Event Response
    @objc private func gotoCalendar() {
        let tataDailyController = ArticleCollectionController(with: "塔塔报")
        tataDailyController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tataDailyController, animated: true)
    }
    
    @objc private func gotoMine() {
        let mineHomeController = MineHomeController()
        let mineHomeNav = UINavigationController(rootViewController: mineHomeController)
        present(mineHomeNav, animated: true, completion: nil)
    }
    
    @objc fileprivate func gotoCategory() {
        let categoryVC = CategoryCollectionController()
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
    fileprivate var _categoryButton: UIButton?
}

// MARK: - TableView Data Source
extension ArticleHomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        } else {
            return 66
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeTataCell.self), for: indexPath) as! ArticleHomeTataCell
                cell.titleText = "塔塔报 | 0520"
                cell.picUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505393598169&di=5b7bc88e0dc4e74721e868bd0fd8b03b&imgtype=0&src=http%3A%2F%2Fimg.weixinyidu.com%2F150921%2Ff9718e53.jpg"
                cell.contentText = "英国有一个最佳设计效率奖，今年颁给了一款“胶水”"
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeNormalCell.self), for: indexPath) as! ArticleHomeNormalCell
                cell.titleText = "烧脑高科技 | 08:01"
                cell.picUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506049096&di=fe3aad8046acf9612b51dc81365f820b&imgtype=jpg&er=1&src=http%3A%2F%2Ftupian.enterdesk.com%2F2015%2Flcx%2F1%2F26%2F7%2F3.jpg"
                cell.contentText = "无人驾驶汽车的“智商”还不如马车，这个风口对消费者来说还有点早"
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeTextCell.self), for: indexPath) as! ArticleHomeTextCell
                cell.titleText = "乐活 | 12:32"
                cell.username = "蒙蒙西"
                cell.usercomment = "最近买了一部新手机，就把旧手机扔在一边，没管他。这货每天自己定时开机关机，还准时闹铃，用着仅存的一格电努力辛勤的工作着，突然觉得好感动，觉得自己真残忍。"
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomePicCell.self), for: indexPath) as! ArticleHomePicCell
                cell.titleText = "映像 | 13:20"
                cell.contentText = "中超、NBA 都要变成短视频了，今日头条和微博们会把体育比赛带到哪里？"
                cell.picArr = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505725655865&di=b29c9a6678f3a7dab02cbd2dc3327977&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F15%2F13%2F60%2F54x58PICP3s_1024.jpg",
                                "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2181405362,1410469512&fm=11&gp=0.jpg",
                                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505725679857&di=f34e02245a9c870dfee2fe1b13519310&imgtype=0&src=http%3A%2F%2Fossweb-img.qq.com%2Fupload%2Fwebplat%2Finfo%2Fxx%2F201112%2F1324302785_-1719592020_17081_imageAddr.jpg",
                                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505725693998&di=2578a27de0cb2ae45b5b950853bdae6d&imgtype=0&src=http%3A%2F%2Fs3.sinaimg.cn%2Forignal%2F49786edb7dd6d9b9cd892",
                                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505725706821&di=ac7ddf53163051d45152e2f553dc1f52&imgtype=0&src=http%3A%2F%2Ffile.wisetravel.cn%2Forigin_b%2F36f8dac7a54548a8bdaf5e317c1190fed32b59b3.jpeg%3Fv1.93",
                                "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1664351629,3380366627&fm=27&gp=0.jpg",
                                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505725737066&di=553d145eb4083382ca1ee1c58f46c892&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160805%2F67b6a3a6ba2e4bbd9c2be59d24fc5667_th.jpg",
                                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506320474&di=a1cafd3fa6d5aa8fb83c3d392791355d&imgtype=jpg&er=1&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3Df4f4e8e0eafe9925df0161135cc134aa%2Fbd315c6034a85edf436c0e0643540923dd547537.jpg",
                                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506320487&di=92d1af363fb6f93d1a81803dd5013731&imgtype=jpg&er=1&src=http%3A%2F%2Fdimg09.c-ctrip.com%2Fimages%2F10020800000031w4xB7E9_R_1024_10000_Q90.jpg"]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeNormalCell.self), for: indexPath) as! ArticleHomeNormalCell
                cell.titleText = "视界 | 08:10"
                cell.picUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506320745&di=eefe996461f058b484cdebb05375f00b&imgtype=jpg&er=1&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D22889bfbf8d3572c72ef949fe27a0952%2F10dfa9ec8a1363274a890e219b8fa0ec08fac7b8.jpg"
                cell.contentText = "如何用最少的钱在逼仄的环境里搭建一个家庭影院"
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeTataCell.self), for: indexPath) as! ArticleHomeTataCell
            cell.titleText = "塔塔报 | 0520"
            cell.picUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505393598169&di=5b7bc88e0dc4e74721e868bd0fd8b03b&imgtype=0&src=http%3A%2F%2Fimg.weixinyidu.com%2F150921%2Ff9718e53.jpg"
            cell.contentText = "英国有一个最佳设计效率奖，今年颁给了一款“胶水”"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let headerView = ArticleSectionHeaderView(reuseIdentifier: String(describing: ArticleSectionHeaderView.self))
            headerView.date = "TUSEDAY, MAR.19"
            return headerView
        } else {
            return nil
        }
    }
}

// MARK: - TableView Delegate
extension ArticleHomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dailyCheckController = DailyCheckController()
        dailyCheckController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dailyCheckController, animated: true)
    }
}

// MARK: - Getters and Setters
extension ArticleHomeController {
    fileprivate var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _tableView?.backgroundColor = Color.hexf5f5f5
            _tableView?.showsVerticalScrollIndicator = false
            _tableView?.register(ArticleHomeTataCell.self, forCellReuseIdentifier: String(describing: ArticleHomeTataCell.self))
            _tableView?.register(ArticleHomeNormalCell.self, forCellReuseIdentifier: String(describing: ArticleHomeNormalCell.self))
            _tableView?.register(ArticleHomeTextCell.self, forCellReuseIdentifier: String(describing: ArticleHomeTextCell.self))
            _tableView?.register(ArticleHomePicCell.self, forCellReuseIdentifier: String(describing: ArticleHomePicCell.self))
            _tableView?.register(ArticleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: ArticleSectionHeaderView.self))
            _tableView?.estimatedRowHeight = Size.screenWidth + 156
            _tableView?.rowHeight = UITableViewAutomaticDimension
            _tableView?.separatorStyle = .none
            _tableView?.mj_header = MJRefreshNormalHeader()
            _tableView?.mj_footer = MJRefreshAutoNormalFooter()
            
            return _tableView!
        }
        
        return _tableView!
    }
    
    fileprivate var categoryButton: UIButton {
        if _categoryButton == nil {
            _categoryButton = UIButton()
            _categoryButton?.setImage(UIImage(named: Icon.categoryIcon), for: .normal)
            _categoryButton?.setImage(UIImage(named: Icon.categoryIcon), for: .highlighted)
            _categoryButton?.addTarget(self, action: #selector(gotoCategory), for: .touchUpInside)
            
            return _categoryButton!
        }
        
        return _categoryButton!
    }
}
