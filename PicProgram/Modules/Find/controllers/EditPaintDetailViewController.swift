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
    var paintModel:PaintModel!
    @IBAction func changeCover(_ sender: Any) {
        let vc = ChangeCoverPicturesViewController()
        vc.chooseCoverPic = {[weak self](index) in
            let picModel = self?.paintModel.picture_arry[index]
            self?.picImageView.xs_setImage((picModel?.picture_url)!)
            self?.paintModel.title_url = (picModel?.picture_url)!
            self?.paintModel.title_detail_url = (picModel?.detail_url)!
            vc.navigationController?.popViewController(animated: true)
        }
        vc.dataSource = self.paintModel.picture_arry
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func updatePainInfoAction(_ sender: Any) {
        //本地画单信息更新
        saveEditPaintInfo()
        HUDTool.show(.text, text: MRLanguage(forKey: "Edit Paint info successful"), delay: 0.6, view: self.view) {
            [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = MRLanguage(forKey: "Edit paint info")
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleTextField.text = self.paintModel.paint_title
        self.subTitleTextField.text = self.paintModel.sub_title
        if self.paintModel.paint_detail != nil && self.paintModel.paint_detail.count as! Int > 0 {
            self.placeholderLabel.isHidden = true
            self.introduceTextView.text = self.paintModel.paint_detail
        }
        if self.paintModel.title_url != nil && self.paintModel.title_url.count as! Int  > 0 {
            self.picImageView.xs_setImage(self.paintModel.title_url)
        }
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
            self.paintModel.sub_title = textField.text!
        }
//        saveEditPaintInfo()
    }
    
    func saveEditPaintInfo() {
        let paint = Paint.fetchPaint(key: .name, value: paintModel.paint_title)
        paint?.coverValues(model: paintModel)
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
