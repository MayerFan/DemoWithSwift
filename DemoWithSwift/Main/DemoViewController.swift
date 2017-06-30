//
//  DemoViewController.swift
//  DemoWithSwift
//
//  Created by MayerF on 2017/6/29.
//  Copyright © 2017年 HZTC. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController,UIScrollViewDelegate {
    let scrollView = UIScrollView()
    let contentSizeView = UIView()
    var barImageView: UIView?
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
    var photo: UIImageView?
    var name: UILabel?
    let menuView = RadioMenuView()
    let bottomView = DemoBottomView()
    var menuViewDistance: CGFloat?

    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        title = "demo"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.edgesForExtendedLayout = .all
        self.automaticallyAdjustsScrollViewInsets = false
        barImageView = self.navigationController?.navigationBar.subviews.first
        
        titleLabel.text = "demo"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.isHidden = true
        self.navigationItem.titleView = titleLabel
        scrollView.delegate = self
        
        photo = UIImageView()
        photo!.image = UIImage(named: "photo")
        photo!.layer.cornerRadius = 30
        photo!.layer.masksToBounds = true
        name = UILabel()
        name?.text = "demo"
        name!.textAlignment = .center
        
        menuView.backgroundColor = .brown
        menuView.setTitles(titles: ["列表1","列表2","列表3"])
        bottomView.setAssociatedClass(content: [TestOneView.self, TestTwoView.self, TestThreeView.self])
        let closure: ((Int) -> Void) = { [weak self](index: Int) in
            self?.menuView.selecteItem(index: index)
        }
        bottomView.scrollCallBack = closure
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentSizeView)
        contentSizeView.addSubview(photo!)
        contentSizeView.addSubview(name!)
        contentSizeView.addSubview(menuView)
        contentSizeView.addSubview(bottomView)
        initConstraints()
        
        contentSizeView.bringSubview(toFront: menuView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kViewWillAppearKey), object: nil)
    }
    func initConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        contentSizeView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(bottomView.snp.bottom)
        }
        photo?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(contentSizeView)
            make.top.equalTo(contentSizeView).offset(64)
            make.width.height.equalTo(60)
        })
        name?.snp.makeConstraints({ (make) in
            make.top.equalTo(photo!.snp.bottom).offset(10)
            make.left.right.equalTo(contentSizeView)
            make.height.equalTo(20)
        })
        menuView.snp.makeConstraints { (make) in
            make.top.equalTo(name!.snp.bottom).offset(10)
            make.left.right.equalTo(contentSizeView)
            make.height.equalTo(30)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(name!.snp.bottom).offset(40)
            make.left.right.equalTo(contentSizeView)
            make.height.equalTo(700)
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    func updateMenuConstraints(offset: CGFloat) {
        menuView.snp.updateConstraints { (make) in
            make.top.equalTo(name!.snp.bottom).offset(offset)
        }
    }
    //MARK: -
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleLabel.isHidden = false
        let offsetY = scrollView.contentOffset.y
        var alphaValue: CGFloat = 0.0
        if offsetY <= 64 && offsetY > 0  {
            alphaValue = offsetY/64
        }else if offsetY <= 0 {
            alphaValue = 0
        }else {
            alphaValue = 1
        }
        barImageView!.backgroundColor = .blue
        barImageView!.alpha = alphaValue
        titleLabel.alpha = alphaValue
        debugPrint("/////\(offsetY)")
        //悬浮逻辑
        if offsetY >= menuViewDistance! {
            updateMenuConstraints(offset: offsetY - menuViewDistance! + 10)
        }else {
            updateMenuConstraints(offset: 10)
        }
    }
    
    override func viewDidLayoutSubviews() {
        debugPrint("\(menuView.frame.origin.y)")
        menuViewDistance = menuView.frame.origin.y - 64
    }
    
}


