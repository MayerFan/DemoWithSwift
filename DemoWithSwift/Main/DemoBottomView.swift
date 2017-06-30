//
//  DemoBottomView.swift
//  DemoWithSwift
//
//  Created by MayerF on 2017/6/29.
//  Copyright © 2017年 HZTC. All rights reserved.
//
//  **************** 底部切换视图 *********************

import UIKit

let kViewWillAppearKey = "DemoBottomViewWillAppearKey"

class DemoBottomView: UIScrollView, UIScrollViewDelegate {
    let contentSizeView = UIView()
    let leftView = UIView()
    let currentView = UIView()
    let rightView = UIView()
    var leftIndex: Int?
    var currentIndex: Int?
    var rightIndex: Int?
    var currentPage = 0
    var classArray: [AnyClass] = []
    var scrollCallBack: ((Int) -> Void)?
    
    //MARK: -
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCommon()
        initConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCommon() {
        self.delegate = self
//        self.bounces = false
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        
        self.addSubview(contentSizeView)
        contentSizeView.addSubview(leftView)
        contentSizeView.addSubview(currentView)
        contentSizeView.addSubview(rightView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: NSNotification.Name(rawValue: kViewWillAppearKey), object: nil)
    }
    private func initConstraints() {
        contentSizeView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self).multipliedBy(3)
        }
        leftView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(contentSizeView)
            make.width.equalTo(self)
        }
        currentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentSizeView)
            make.left.equalTo(leftView.snp.right)
            make.right.equalTo(rightView.snp.left)
            make.width.equalTo(leftView)
        }
        rightView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(contentSizeView)
            make.width.equalTo(leftView)
        }
    }
    //MARK: -
    //MARK: public
    func setAssociatedClass(content: [AnyClass]) {
        classArray.append(contentsOf: content);
        
        currentIndex = 0;
        currentPage = 0;
        leftIndex = currentIndex! - 1 < 0 ? (content.count - 1) : currentIndex! - 1;
        rightIndex = currentIndex! + 1 > (content.count-1) ? (0) : currentIndex! + 1;
        
        reloadView()
    }
    //MARK: -
    //MARK: private
    func reloadView() {
        for view in leftView.subviews {
            view.removeFromSuperview()
        }
        for view in currentView.subviews {
            view.removeFromSuperview()
        }
        for view in rightView.subviews {
            view.removeFromSuperview()
        }
        let leftClass: AnyClass = classArray[leftIndex!] as AnyClass
        let leftObj: UIView = (leftClass as! UIView.Type).init()
        let currentClass: AnyClass = classArray[currentIndex!] as AnyClass
        let currentObj: UIView = (currentClass as! UIView.Type).init()
        let rightClass: AnyClass = classArray[rightIndex!] as AnyClass
        let rightObj: UIView = (rightClass as! UIView.Type).init()
        leftView.addSubview(leftObj)
        currentView.addSubview(currentObj)
        rightView.addSubview(rightObj)
        leftObj.snp.makeConstraints { (make) in
            make.edges.equalTo(leftView)
        }
        currentObj.snp.makeConstraints { (make) in
            make.edges.equalTo(currentView)
        }
        rightObj.snp.makeConstraints { (make) in
            make.edges.equalTo(rightView)
        }
    }
    //MARK: -
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if (offsetX < 0) {
            currentIndex = leftIndex;
            rightIndex = currentIndex! + 1 > (classArray.count-1) ? (0) : currentIndex! + 1
            leftIndex = currentIndex! - 1 < 0 ? (classArray.count - 1) : currentIndex! - 1
            reloadView()
            self.contentOffset = CGPoint(x: self.frame.width, y: 0)
            return
        }else if (offsetX > self.frame.width*2) {
            currentIndex = rightIndex;
            rightIndex = currentIndex! + 1 > (classArray.count-1) ? (0) : currentIndex! + 1
            leftIndex = currentIndex! - 1 < 0 ? (classArray.count - 1) : currentIndex! - 1
            reloadView()
            self.contentOffset = CGPoint(x: self.frame.width, y: 0)
            return
        }
        //调整Page切换逻辑
        if (offsetX > self.frame.width*3/2) {
            currentPage = currentIndex! + 1 > (classArray.count-1) ? (0) : currentIndex! + 1;
        }else if (offsetX < self.frame.width/2) {
            currentPage = currentIndex! - 1 < 0 ? (classArray.count - 1) : currentIndex! - 1;
        }else {
            currentPage = currentIndex!;
        }
        if let closure = scrollCallBack {
            closure(currentPage);
        }
    }
    //MARK: -
    //MARK: notification
    func viewWillAppear() {
        self.contentOffset = CGPoint(x: self.frame.width, y: 0)
    }

}
