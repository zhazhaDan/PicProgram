//
//  PictureDetailViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/3.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

let HistoryPaintName = "\(MRLanguage(forKey: "My Account"))\(MRLanguage(forKey: "History Viewed"))"

class PictureDetailViewController: BaseViewController {

    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var picInfoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    private var _model:PictureModel!
    var model:PictureModel {
        set{
            _model = newValue
        }
        get{
            return _model
        }
    }
    var isUpdatePicture:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isUpdatePicture == true {
            requestData()
        }else {
           self.updateUI()
        }
        fetchHistoryPaint()
    }
    
    func fetchHistoryPaint() {
        let paint = Paint.fetchPaint(key: .name, value: HistoryPaintName, create: true, painttype: 3)
        let picture = Picture.fetchPicture(forPicId: Int64(model.picture_id))
        if (paint?.pics?.contains(picture))! {
            paint?.removeFromPics(picture!)
        }
        picture?.coverProperties(model: model)
        paint?.addToPics(picture!)
        do {
            try appDelegate.managedObjectContext.save()
        }catch {}
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func updateUI() {
        self.titleLabel.text = model.title
        picImageView.xs_setImage(model.detail_url)
        autorLabel.text = model.author
        if model.time.count as! Int > 0 {
            timeLabel.text = model.time + MRLanguage(forKey: "made")
        }
        picInfoLabel.text = model.detail
    }

    override func requestData() {
        network.requestData(.picture_info, params: ["picture_id":model.picture_id], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                self?.model.setValuesForKeys(result["picture_detail"] as! [String : Any])
                self?.updateUI()
            }
        }, nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
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
