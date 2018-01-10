//
//  WebViewController.swift
//  PicProgram
//
//  Created by sliencio on 2017/11/8.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import  WebKit


class WebViewController: BaseViewController,WKUIDelegate,WKNavigationDelegate {

    var webView:WKWebView!
    var _urlString:String!
    var urlString:String {
        set{
            _urlString = newValue

        }
        get{
            return _urlString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let config =  WKWebViewConfiguration.init()
        let commonRect = CGRect.init(x: 0, y: NavigationBarBottom, width: self.view.width, height: self.view.height - NavigationBarBottom)

        webView = WKWebView.init(frame: commonRect, configuration:config)
        self.view.addSubview(webView)
        if urlString.count as! Int > 0 {
            let request = URLRequest.init(url: URL.init(string: urlString)!)
            webView.load(request)
        }
        // Do any additional setup after loading the view.
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //页面加载成功
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //页面加载失败
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
