//
//  EditPaintDetailViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/13.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class EditPaintDetailViewController: BaseViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textLengthLabel: UILabel!
    var paintModel:Paint!
    @IBAction func changeCover(_ sender: Any) {
        let vc = ChangeCoverPicturesViewController()
        vc.chooseCoverPic = {[weak self](index) in
            let picModel = self?.paintModel.pictureModels[index]
            self?.picImageView.xs_setImage((picModel?.picture_url)!)
            self?.paintModel.title_url = (picModel?.picture_url)!
        }
        vc.dataSource = self.paintModel.pictureModels
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func updatePainInfoAction(_ sender: Any) {
        //本地画单信息更新
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑画单信息"
        self.titleTextField.text = self.paintModel.paint_title
        self.picImageView.xs_setImage(self.paintModel.title_url!)
        // Do any additional setup after loading the view.
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.count >= 36 {
            let str = textView.text
            let index = str?.index((str?.startIndex)!, offsetBy: 36)
            textView.text = textView.text.substring(to: index!)
        }
       
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count >= 36 && text != "" {
            return false
        }
       
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 36 {
            let str = textView.text
            let index = str?.index((str?.startIndex)!, offsetBy: 36)
            textView.text = textView.text.substring(to: index!)
        }
        if self.introduceTextView.text.count == 0 {
            self.placeholderLabel.isHidden = false
        }else {
            self.placeholderLabel.isHidden = true
        }
        
        self.textLengthLabel.text = "\(36 - self.introduceTextView.text.count)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.paintModel.paint_title = textField.text!
    }
    
    @IBAction func tapAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
