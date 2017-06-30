//
//  RootViewController.swift
//  DemoWithSwift
//
//  Created by MayerF on 2017/6/29.
//  Copyright © 2017年 HZTC. All rights reserved.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    var jumpBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        jumpBtn = UIButton()
        jumpBtn?.setTitle("jumpToDemo", for: .normal)
        jumpBtn?.addTarget(self, action: #selector(jumpOnClick), for: .touchUpInside)
        jumpBtn?.backgroundColor = .blue
        
        view.addSubview(jumpBtn!)
        jumpBtn?.snp.makeConstraints({ (make) in
            make.center.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(90)
        })
    }
    
    @objc private func jumpOnClick() {
        self.navigationController?.pushViewController(DemoViewController(), animated: true)
    }

}
