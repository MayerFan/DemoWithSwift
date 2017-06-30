//
//  RadioMenuView.swift
//  DemoWithSwift
//
//  Created by MayerF on 2017/6/29.
//  Copyright © 2017年 HZTC. All rights reserved.
//
//  **************** 选中菜单视图控件 *********************

import UIKit

class RadioMenuView: UIView {
    lazy var btnsArray: [UIButton] = []
    let underLine = UIView()
    var lineH = 1
    var lineColor: UIColor? {
        willSet {
            
        }
    }
    
    //MARK: -
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCommon()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCommon() {
        lineColor = lineColor ?? .red
        underLine.backgroundColor = lineColor!
        self.addSubview(underLine)
    }
    //MARK: -
    //MARK: public
    func setTitles(titles: [String]) {
        setTitles(titles: titles, selectedIndex: 0)
    }
    func setTitles(titles: [String], selectedIndex: Int) {
        if titles.count < 2 {
            return
        }
        btnsArray.removeAll()
        for title in titles {
            let btn = UIButton()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.red, for: .selected)
            btn.addTarget(self, action: #selector(btnOnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            btnsArray.append(btn)
        }
        
        setDefaultConstraints(index: selectedIndex)
    }
    func updateTitles(titles: [String]) {
        
    }
    func selecteItem(index: Int) {
        for btnView in btnsArray {
            btnView.isSelected = false
        }
        let btn = btnsArray[index]
        btn.isSelected = true
        updateUnderLineConstraints(index: index)
    }
    
    //MARK:-
    //MARK: private
    private func setDefaultConstraints(index: Int) {
        if btnsArray.count == 2 {
            let oneBtn = btnsArray[0]
            let twoBtn = btnsArray[1]
            oneBtn.snp.makeConstraints({ (make) in
                make.top.left.bottom.equalTo(self)
                make.right.equalTo(twoBtn.snp.left)
            })
            twoBtn.snp.makeConstraints({ (make) in
                make.top.right.bottom.equalTo(self)
                make.width.equalTo(oneBtn)
            })
            return
        }
        var preObj: UIButton?
        for btn in btnsArray {
            if btn === btnsArray[0]  {
                btn.snp.makeConstraints({ (make) in
                    make.top.left.bottom.equalTo(self)
                })
            }else if btn === btnsArray.last {
                btn.snp.makeConstraints({ (make) in
                    make.right.equalTo(self)
                    make.left.equalTo(preObj!.snp.right)
                    make.width.height.top.equalTo(preObj!)
                })
            }else {
                btn.snp.makeConstraints({ (make) in
                    make.left.equalTo(preObj!.snp.right)
                    make.width.height.top.equalTo(preObj!)
                })
            }
            
            preObj = btn
        }
        
        let btn = btnsArray[index]
        underLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn)
            make.bottom.equalTo(self)
            make.width.equalTo(btn).multipliedBy(0.5)
            make.height.equalTo(lineH)
        }
    }
    private func updateUnderLineConstraints(index: Int) {
        let btn = btnsArray[index]
        underLine.snp.remakeConstraints { (make) in
            make.centerX.equalTo(btn)
            make.bottom.equalTo(self)
            make.width.equalTo(btn).multipliedBy(0.5)
            make.height.equalTo(lineH)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func btnOnClick(btn: UIButton) {
        for btnView in btnsArray {
            btnView.isSelected = false
        }
        btn.isSelected = true
        updateUnderLineConstraints(index: btnsArray.index(of: btn)!)
    }
}
