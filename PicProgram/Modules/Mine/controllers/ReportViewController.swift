//
//  ReportViewController.swift
//  PicProgram
//
//  Created by sliencio on 2018/1/8.
//  Copyright © 2018年 龚丹丹. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController,UITextViewDelegate {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = MRLanguage(forKey: "User Review")
        // Do any additional setup after loading the view.
    }
    @IBAction func submitReportAction(_ sender: Any) {
        if (textView.text.count as! Int) <= 0 {
            return
        }
        HUDTool.show(.loading, view: self.view)
        network.requestData(.user_report, params: ["content":textView.text], finishedCallback: { (result) in
           HUDTool.hide()
            if result["ret"] as! Int == 0 {
                HUDTool.show(.text, nil, text: MRLanguage(forKey: "Upload Successful"), delay: 0.8, view: self.view, complete: {
                    self.navigationController?.popViewController(animated: true)
                })
            }else {
                HUDTool.show(.text, nil, text: result["err"] as! String, delay: 0.8, view: self.view, complete: nil)
            }
        }, nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = xsColor_main_background
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.count >= 200 {
            let str = textView.text
            let index = str?.index((str?.startIndex)!, offsetBy: 200)
            textView.text = textView.text.substring(to: index!)
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count >= 200 && text != "" {
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 200 {
            let str = textView.text
            let index = str?.index((str?.startIndex)!, offsetBy: 200)
            textView.text = textView.text.substring(to: index!)
        }
        if self.textView.text.count == 0 {
            self.placeholderLabel.isHidden = false
        }else {
            self.placeholderLabel.isHidden = true
        }
        
        self.numberLabel.text = "\(200 - self.textView.text.count)"
    }
    

}
