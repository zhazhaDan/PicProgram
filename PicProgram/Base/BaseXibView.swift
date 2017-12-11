//
//  BaseXibView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/10.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class BaseXibView: UIView {
    @IBOutlet weak var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        let className = NSStringFromClass(self.classForCoder) as! NSString
        let programName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! NSString
        let index = programName.length
        let str = className.substring(from: index+1)
        Bundle.main.loadNibNamed(str, owner: self, options: nil)
        self.addSubview(self.view)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
