//
//  WifiSettingView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/16.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

class WifiSettingView: BaseView {
    @IBOutlet weak var wifiTitleLabel: UILabel!
    @IBOutlet weak var wifiNameTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var statusButton: UIButton!
    @IBAction func connectWifiAction(_ sender: Any) {
        let codeString = wifiNameTextfield.text! + "&" + passTextfield.text! + "&2"
        self.wifiCodeView.isHidden = false
        
        wifiQrCodeImageView.image = codeString.generateQRCodeImage(color: xsColor_main_blue,orientation: .rightMirrored)
    }
    
     
    
    @IBAction func tapAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    @IBOutlet weak var wifiSettingView: UIView!
    @IBOutlet weak var wifiCodeView: UIView!
    @IBOutlet weak var wifiQrCodeImageView: UIImageView!
    @IBAction func rememberAction(_ sender: Any) {
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wifiNameTextfield.text = getUsedSSID()
        wifiNameTextfield.rightViewMode = .always
        wifiNameTextfield.leftViewMode = .always
        passTextfield.leftViewMode = .always
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "icons8-wifi"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: 50, height: 30)
        imageView.contentMode = .scaleAspectFit
        wifiNameTextfield.rightView = imageView
        
        let spaceView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        wifiNameTextfield.leftView = spaceView1
        let spaceView2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        passTextfield.leftView = spaceView2
    }
    
    func getUsedSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
    }
 
}
