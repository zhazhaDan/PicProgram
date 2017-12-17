//
//  GifViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/5.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class GifViewController: BaseViewController,UIWebViewDelegate {
    var webview:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func buildUI() {
        webview = UIWebView.init(frame: CGRect.init(x: 0, y: -StatusBarHeight, width: self.view.width, height: SCREEN_HEIGHT))
        self.view.addSubview(webview)
        webview.delegate = self
        webview.scalesPageToFit = true
        webview.scrollView.isScrollEnabled = false
        let path = Bundle.main.path(forResource: "moran", ofType: ".gif")
        if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!)) {
            webview.load(data as Data, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL: Bundle.main.resourceURL!)
        }
        let skitButton = UIButton.init(frame: CGRect.init(x: self.view.width - 28 - 72.5, y: 50, width: 72.5, height: 23))
//        skitButton.backgroundColor = xsColor_main_yellow
//        skitButton.setTitle("点击跳过", for: .normal)
        skitButton.setImage(#imageLiteral(resourceName: "kaijitiaoguo"), for: .normal)
//        skitButton.setImage(#imageLiteral(resourceName: "kaijitiaoguo"), for: .highlighted)
        skitButton.addTarget(self, action: #selector(skitGifView), for: .touchUpInside)
//        skitButton.titleLabel?.font = xsFont(12)
        self.view.addSubview(skitButton)
    }
    
    @objc func skitGifView() {
//        webview.stopLoading()
        appDelegate.gifDone()
//        appDelegate.window?.rootViewController = BaseTabBarController()

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
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
