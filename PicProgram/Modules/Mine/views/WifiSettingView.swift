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
        wifiQrCodeImageView.image = generateQRCodeImage(info: codeString)
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
    /// 生成二维码
    private func generateQRCodeImage(info:String) -> UIImage {
        
        // 1. 生成二维码
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setDefaults()
        qrFilter.setValue("任玉飞".data(using: String.Encoding.utf8), forKey: "inputMessage")
        let ciImage = qrFilter.outputImage
        
        // 2. 缩放处理
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let transformImage = ciImage?.transformed(by: transform)
        
        // 3. 颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(transformImage, forKey: "inputImage")
        // 前景色
        colorFilter.setValue(CIColor(color: xsColor_main_yellow), forKey: "inputColor0")
        // 背景色
        colorFilter.setValue(CIColor(color: UIColor.white), forKey: "inputColor1")
        
        let outputImage = colorFilter.outputImage
        
//        return insertAvatarImage(qrimage: UIImage(CIImage: outputImage!), avatar: UIImage(named: "avatar")!)
        return UIImage.init(ciImage: outputImage!)
    }
    
    func insertAvatarImage(qrimage: UIImage, avatar: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(qrimage.size)
        
        let rect = CGRect(origin: CGPoint.zero, size: qrimage.size)
        qrimage.draw(in: rect)
        
        let w = rect.width * 0.2
        let x = (rect.width - w) * 0.5
        let y = (rect.height - w) * 0.5
        avatar.draw(in: CGRect(x: x, y: y, width: w, height: w))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
