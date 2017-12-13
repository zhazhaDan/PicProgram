//
//  GifViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/5.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class GifViewController: BaseViewController,UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func buildUI() {
        let webview = UIWebView.init(frame: CGRect.init(x: 0, y: -StatusBarHeight, width: self.view.width, height: SCREEN_HEIGHT))
        self.view.addSubview(webview)
        webview.delegate = self
        webview.scalesPageToFit = true
        let path = Bundle.main.path(forResource: "moran", ofType: ".gif")
        if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!)) {
            webview.load(data as Data, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL: Bundle.main.resourceURL!)
        }
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
