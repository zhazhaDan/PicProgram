//
//  NewPintNameViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/12/11.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import CoreData

class NewPintNameViewController: BaseViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        self.title = "新建画单"
        self.navigationController?.navigationBar.barTintColor = xsColor("fcf9eb")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:xsColor_main_text_blue]
        self.baseNavigationController?.addLeftNavigationBarItem {
            self.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 10 {
            let btn = self.view.viewWithTag(11) as! UIButton
            sender.isSelected = true
            btn.isSelected = false
            if (textField.text?.count)! > 0 && (textField.text?.count)! < 20 {
                if let paint = Paint.fetchPaint(key: .name, value: textField.text, create: false) {
                    HUDTool.show(.text, text: "画单已存在", delay: 1, view: self.view, complete: nil)
                }else {
                    let entity = NSEntityDescription.entity(forEntityName: "Paint", in:  appDelegate.managedObjectContext) as! NSEntityDescription
                    let paint = NSManagedObject.init(entity: entity, insertInto: appDelegate.managedObjectContext) as! Paint
                    paint.paint_title = textField.text
                    paint.paint_type = 1
                    do {
                        try appDelegate.managedObjectContext.save()
                        //TODO:通知新建画单成功
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_LocalPaintCreateSuccessful), object: paint)
                        self.dismiss(animated: true, completion: nil)
                    }catch {
                        
                    }
                }
               
            }
        }else if sender.tag == 11 {
            let btn = self.view.viewWithTag(10) as! UIButton
            sender.isSelected = true
            btn.isSelected = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
