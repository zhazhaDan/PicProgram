//
//  NoWifiViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/19.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class NoWifiViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func buildUI() {
        let backImageView = UIImageView.init(image: #imageLiteral(resourceName: "beijing"))
        backImageView.contentMode = .scaleAspectFill
        backImageView.frame = self.view.bounds
        self.view.addSubview(backImageView)
        let wifiImageView = UIImageView.init(image: #imageLiteral(resourceName: "nowifi"))
        wifiImageView.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y )
        self.view.addSubview(wifiImageView)
        let label = UILabel.initializeLabel(CGRect.init(x: 50, y: wifiImageView.bottom + 52, width: self.view.width - 100, height: 50), font: 15, textColor: xsColor_main_yellow, textAlignment: .center)
        label.text = MRLanguage(forKey: "NO WiFi")
        label.numberOfLines = 0
        self.view.addSubview(label)
        backImageView.isUserInteractionEnabled = true
        wifiImageView.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
    }
 
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
