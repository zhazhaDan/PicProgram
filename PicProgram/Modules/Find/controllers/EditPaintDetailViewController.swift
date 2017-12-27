//
//  EditPaintDetailViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/13.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class EditPaintDetailViewController: BaseViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var subTitleTextField: UITextField!
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
            self?.paintModel.title_detail_url = (picModel?.detail_url)!
            vc.navigationController?.popViewController(animated: true)
        }
        vc.dataSource = self.paintModel.pictureModels
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func updatePainInfoAction(_ sender: Any) {
        //本地画单信息更新
        saveEditPaintInfo()
        HUDTool.show(.text, text: "画单信息修改成功", delay: 0.6, view: self.view) {
            [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑画单信息"
        self.titleTextField.text = self.paintModel.paint_title
        if self.paintModel.title_url != nil && self.paintModel.title_url?.count as! Int  > 0 {
            self.picImageView.xs_setImage(self.paintModel.title_url!)
        }
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
        }else if text == "" {
            tapAction()
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
        self.paintModel.paint_detail = textView.text
//        saveEditPaintInfo()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapAction()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            self.paintModel.paint_title = textField.text!
        }else if textField == subTitleTextField {
            //TODO:画单副标题
//            self.paintModel.paint_detail
        }
//        saveEditPaintInfo()
    }
    
    func saveEditPaintInfo() {
        do {
            try appDelegate.managedObjectContext.save()
        } catch {
        }
    }
    
    @IBAction func tapAction(_ sender: Any?=nil) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
