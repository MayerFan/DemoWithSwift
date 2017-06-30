//
//  TestOneView.swift
//  DemoWithSwift
//
//  Created by MayerF on 2017/6/29.
//  Copyright © 2017年 HZTC. All rights reserved.
//

import UIKit

class TestOneView: UIView {
    let flag = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flag.text = "TestOneView"
        addSubview(flag)
        flag.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
