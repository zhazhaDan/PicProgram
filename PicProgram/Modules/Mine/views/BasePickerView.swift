//
//  BasePickerView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/15.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

enum PickerType {
    case gender
    case birthday
}

class BasePickerView: BaseView,UIPickerViewDelegate,UIPickerViewDataSource {

    var type:PickerType = PickerType.gender
    private let genderTitles = ["男","女","其他"]
    private var gender:String!
    private var birthday:Date!
    var finishChoose : ((_ result:Any)->())?
    func buildUI(type:PickerType,didFinishChoose:@escaping (_ result:Any)->()) {
        self.backgroundColor = xsColor_main_white
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 1))
        lineView.backgroundColor = xsColor_main_yellow
        self.addSubview(lineView)
        let cancelButton = UIButton.init(frame: CGRect.init(x: 0, y: 1, width: 60, height: 38))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(xsColor_main_yellow, for: .normal)
        cancelButton.titleLabel?.font = xsFont(13)
        cancelButton.tag = 10
        cancelButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        self.addSubview(cancelButton)
        let subButton = UIButton.init(frame: CGRect.init(x: self.width - 60, y: 1, width: 60, height: 38))
        subButton.setTitle("确定", for: .normal)
        subButton.setTitleColor(xsColor_main_yellow, for: .normal)
        subButton.titleLabel?.font = xsFont(13)
        subButton.tag = 11
        subButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        self.addSubview(subButton)
        let lineView2 = UIView.init(frame: CGRect.init(x: 0, y: 40, width: self.width, height: 1))
        lineView2.backgroundColor = xsColor_main_yellow
        self.addSubview(lineView2)
        if type == .gender {
            let picker  = UIPickerView.init(frame: CGRect.init(x: 0, y: lineView2.bottom, width: self.width, height: 100))
            picker.delegate = self
            picker.dataSource = self
            picker.backgroundColor = xsColor_main_white
            self.addSubview(picker)
            
        }else {
            let datePicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: lineView2.bottom, width: self.width, height: 150))
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "zh_CN")
            datePicker.maximumDate = Date.init(timeIntervalSinceNow: 0)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"

            let minDate = dateFormatter.date(from: "1940-01-01")
            datePicker.minimumDate = minDate
            datePicker.date = Date.init(timeIntervalSinceNow: 0)
            datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
            self.addSubview(datePicker)
        }
        finishChoose = {(result) in
            didFinishChoose(result)
        }

    }
    
    @objc func dateChange(_ picker:UIDatePicker) {
        birthday = picker.date
    }
    
    @objc func buttonAction(_ sender:UIButton) {
        if sender.tag == 10 {
            self.removeFromSuperview()
        }else if sender.tag == 11 {
            //确定选择
            if type == .gender {
                finishChoose!(gender)
            }else if type == .birthday {
                finishChoose!(birthday)
            }
            self.removeFromSuperview()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderTitles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderTitles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender = genderTitles[row]
    }
}
