//
//  ClassifyArtListViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/24.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PicDetailCollectionViewCell"
private let headerReuseIdentifier = "ClassifyEmotionCollectionReusableView"

class ClassifyEmotionListViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,CustomViewProtocol {
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var emotionImageView: UIImageView!
    @IBOutlet weak var classTitleButton: UIButton!
    @IBOutlet weak var showVBackView: UIView!
    @IBOutlet weak var showTableListView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var last_id:Int32 = 0
      var dataSource: Array<[String:Any]>!
    var selectedIndex:Int = 0
    var model:PaintModel!
    var customPaint:[PictureModel] = Array()
    var emotion:Emotion!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = MRLanguage(forKey: "Mood")
        self.baseNavigationController?.addRightNavigationBarItems(["08wode_shebeiguanli"], ["08wode_shebeiguanli"]) { [weak self](tag) in
            if UserInfo.user.checkUserLogin() {
                let vc = PlayViewController.player
                self?.navigationController?.pushViewController(vc, animated: true)
            }else {
                let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
                let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
                self?.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)
                
            }
            
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let sectionData = self.dataSource[selectedIndex]
        self.emotionImageView.image = UIImage.init(named: sectionData["imageName"]! as! String)
        self.emotionLabel.font = xsFont(20)
        self.emotionLabel.text = sectionData["title"] as! String
       loadLoadEmotionPaint()
    }

    override func buildUI() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: "PicDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier:reuseIdentifier)
        collectionView.register(UINib.init(nibName: "ClassifyEmotionCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        showTableListView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func tapChangePaintAction(_ sender: Any) {
         self.showVBackView.isHidden = !self.showVBackView.isHidden
    }
    
    override func requestData() {
        let paint_id = dataSource[selectedIndex]["id"]
        HUDTool.show(.loading, view: self.view)
        network.requestData(.paint_info, params: ["paint_id":paint_id,"last_id":last_id], finishedCallback: { [weak self](result) in
            HUDTool.hide()
            if result["ret"] as! Int == 0 {
                if result["last_id"] != nil {
                    self?.last_id = result["last_id"] as! Int32
                }
                self?.model = PaintModel.init(dict: result["paint_detail"] as! [String : Any])
                self?.collectionView?.reloadData()
            }else {
                HUDTool.show(.text, text: result["err"] as! String, delay: 0.8, view: (self?.view)!, complete: nil)
            }
            }, nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if customPaint.count > 0 && self.model != nil {
            return 2
        }else if customPaint.count == 0 && self.model == nil {
            return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if customPaint.count > 0 && section == 0 {
            return (customPaint.count > 9 ? 9 : customPaint.count)
        }else if self.model == nil {
            return 0
        }else {
            return (model.picture_arry.count > 12 ? 12 : model.picture_arry.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 48)/3, height: (SCREEN_WIDTH - 48)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1, 12, 5, 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ClassifyEmotionCollectionReusableView
            if customPaint.count == 0 {
                view.emotionTitleButton.setTitle(MRLanguage(forKey: "Initical Category"), for: .normal)
            }else {
                if indexPath.section == 0 {
                    view.emotionTitleButton.setTitle(MRLanguage(forKey: "User Customized Setting"), for: .normal)
                }else if indexPath.section == 1 {
                    view.emotionTitleButton.setTitle(MRLanguage(forKey: "Initical Category"), for: .normal)
                }
            }
            view.delegate = self
            view.section = indexPath.section
            return view
        }
        return UICollectionReusableView()
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserInfo.user.checkUserLogin() {
            let vc = PlayViewController.player
            
            if customPaint.count == 0 {
                vc.dataSource = model.picture_arry
                vc.title = model.paint_title
            }else {
                if indexPath.section == 0 {
                    vc.dataSource = customPaint
                    vc.title = MRLanguage(forKey: "History Viewed")
                }else if indexPath.section == 1 {
                    vc.dataSource = model.picture_arry
                    vc.title = model.paint_title
                }
            }
            vc.currentIndex = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)

        }else {
            let sb = UIStoryboard.init(name: "Mine", bundle: Bundle.main)
            let login = sb.instantiateViewController(withIdentifier: "SBLoginViewController")
            self.present(HomePageNavigationController.init(rootViewController:login), animated: true, completion: nil)

        }
       
      
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if customPaint.count == 0 {
            let cell = cell as! PicDetailCollectionViewCell
            let item = model.picture_arry[indexPath.row]
            cell.model = item
        }else {
            if indexPath.section == 0 {
                let cell = cell as! PicDetailCollectionViewCell
                let item = customPaint[indexPath.row]
                cell.model = item
            }else if indexPath.section == 1 {
                let cell = cell as! PicDetailCollectionViewCell
                let item = model.picture_arry[indexPath.row]
                cell.model = item
            }
        }
        
    }
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionData = self.dataSource[indexPath.row]
        cell.imageView?.image = UIImage.init(named: sectionData["imageName"]! as! String)
        cell.textLabel?.text = sectionData["title"] as! String
        if indexPath.row == selectedIndex {
            cell.accessoryView?.isHidden = false
        }else {
            cell.accessoryView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = xsColor_main_yellow
        cell.textLabel?.font = xsFont(12)
        cell.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "04fenlei_yishu-xieshi_xiala_duihao"))
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let sectionData = self.dataSource[indexPath.row]
        self.emotionImageView.image = UIImage.init(named: sectionData["imageName"]! as! String)
        self.emotionLabel.text = sectionData["title"] as! String
        loadLoadEmotionPaint()
        self.tapChangePaintAction(tableView)
        self.showTableListView.reloadData()
        self.requestData()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryView?.isHidden = false
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.row == selectedIndex {
            cell?.accessoryView?.isHidden = false
        }else {
            cell?.accessoryView?.isHidden = true
        }

    }
    
    //为了解决tableivew didselect和tableivew.superview添加手势之后的冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if showTableListView.frame.contains(touch.location(in: touch.view)) {
            return false
        }
        return true
    }
    //点击从本地数据库读取用户自定义列表
    func loadLoadEmotionPaint() {
        let sectionData = self.dataSource[selectedIndex]
        emotion = Emotion.fetchEmotionPaint(forEmotionName: sectionData["title"] as! String)
        customPaint = emotion.pictureModels
        collectionView.reloadData()

    }
    
    //customViewProtocol
    func listDidSelected(view: UIView, at index: Int, _ section: Int) {
        let vc = ClassifyEmotionDetailListViewController.init(nibName: "ClassifyEmotionDetailListViewController", bundle: Bundle.main)
        let header = view as! ClassifyEmotionCollectionReusableView
        if customPaint.count == 0 {
            if section == 0 {
                vc.pictures = self.model.picture_arry
            }
        }else if section == 0 {
            vc.pictures = customPaint
        }else if section == 1 {
            vc.pictures = self.model.picture_arry
        }
        vc.title = self.emotionLabel.text
        let subTitle = header.emotionTitleButton.title(for: .normal)
        vc.subTitle = subTitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
