//
//  SearchViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/25.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseHeaderIdentifier = "header"

class SearchViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SearchProtocol,UITextFieldDelegate {
    var collectionView:UICollectionView!
    var dataSource:Array<[String:Any]> = [["title":"最近搜索","data":["这里","大家好","吴冠中","礼拜","欧阳","一蓑烟雨任平生","尘粒","奇妙能力歌","晚安","够了吗","hello","好","拜"]],
    ["title":"最热搜索","data":["尘粒","奇妙能力歌","欧阳","一蓑烟雨任平生","晚安","够了吗","hello","好","拜","这里","大家好","吴冠中","礼拜"]]]
    var searchResultView:SearchResultView!
    var inputTextField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        customNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func buildUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12)
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: NavigationBarBottom, width: self.view.width, height: self.view.height - NavigationBarBottom), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = xsColor_main_white
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(SearchHeaderReuseableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        self.view.addSubview(collectionView)
        
        searchResultView = SearchResultView.init(frame: collectionView.frame)
        searchResultView.sDelegate = self
//        self.view.addSubview(searchResultView)
    }
    
    func customNavigationBar() {
        inputTextField = UITextField.init(frame: CGRect.init(x: 12, y: StatusBarHeight+7, width: self.view.width - 72, height: 30))
        inputTextField.leftViewMode = .always
        let leftView = UIImageView.init(image: #imageLiteral(resourceName: "04s_shousuo"))
        leftView.contentMode = .scaleAspectFit
        leftView.size = CGSize.init(width: 35, height: 18)
        inputTextField.leftView = leftView
        inputTextField.layer.cornerRadius = 15
        inputTextField.layer.borderColor = xsColor_main_text_blue.cgColor
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.masksToBounds = true
        inputTextField.delegate = self
        inputTextField.clearButtonMode = .whileEditing
        inputTextField.attributedPlaceholder = NSAttributedString.init(string: "艺术品名称／作家", attributes: [NSAttributedStringKey.foregroundColor:xsColor_main_yellow])
        inputTextField.delegate = self
        inputTextField.font = xsFont(14)
        self.view.addSubview(inputTextField)
        
        let cancelButton = UIButton.init(frame: CGRect.init(x: inputTextField.right + 10, y: inputTextField.y, width: 40, height: 30))
        cancelButton.titleLabel?.font = xsBoldFont(14)
        cancelButton.setTitleColor(xsColor_main_text_blue, for: .normal)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    override func requestData() {
        network.requestData(.search_hotwords, params: nil, finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                let datas = result["hot_words"]
                self?.dataSource[1]["data"] = datas
                self?.collectionView.reloadData()
            }
        }, nil)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.searchResultView.removeFromSuperview()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 0 {
            self.searchResultView.removeFromSuperview()
        }
        return true
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dict = dataSource[section]
        let data = dict["data"] as! [String]
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dict = dataSource[indexPath.section]
        let data = dict["data"] as! [String]

        let str = data[indexPath.item]
        let size = str.boundingRect(with: CGSize.init(width: self.view.width, height: 22), options: .usesFontLeading, attributes: nil, context: nil)
        return CGSize.init(width: size.width + 54, height: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: self.view.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        let dict = dataSource[indexPath.section]
        let data = dict["data"] as! [String]
        let str = data[indexPath.item]
        cell.layoutIfNeeded()
        cell.titleLabel.text = "#\(str)#"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! SearchHeaderReuseableView
                header.layoutIfNeeded()
            let dict = dataSource[indexPath.section]
            let title = dict["title"] as! String
            header.titleLabel.text = title
                header.delegate = self
            if title == "最热搜索" {
                header.clearButton.isHidden = true
            }
            return header

        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let datas = dataSource[indexPath.section]["data"] as! [String]
        let keyword = datas[indexPath.row]
        inputTextField.text = keyword
        network.requestData(.search_info, params: ["kw":keyword], finishedCallback: { [weak self](result) in
            if result["ret"] as! Int == 0 {
                let keys = ["picture_info","authro_info","paint_info"]
                for i in 0 ..< keys.count {
                    if result[keys[i]] != nil {
                        let array = result[keys[i]] as! Array<[String:Any]>
                        var data:[BaseObject] =  Array<BaseObject>()
                        for dict in array {
                            
                            var model:BaseObject? = nil
                            switch i+1 {
                            case 1:
                                model = PictureModel.init(dict:dict)
                            case 2:
                                model = PaintModel.init(dict:dict)
                            case 3:
                                model = PaintModel.init(dict:dict)
                            default:
                                model = PictureModel.init(dict:dict)
                            }
                            data.append(model!)
                        }
                        self?.searchResultView.dataSource.append(data)
                    }else {
                        self?.searchResultView.dataSource.append([])
                    }
                }
                self?.searchResultView.reloadDatas()
                self?.view.addSubview((self?.searchResultView)!)
            }
        }, nil)
    }
    
    
    
    func clearnUpHistory() {
        self.dataSource.remove(at: 0)
        self.collectionView.deleteSections(IndexSet.init(integer: 0))
    }
    
    func searchResultDidChoosedCell(view: Int, _ index: Int) {
        if view == SearchResultListType.SearchResultListType_autor.hashValue {
            let layout = UICollectionViewFlowLayout.init()
            let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
            vc.paintModel = (searchResultView.dataSource[view][index] as! PaintModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }else  if view == SearchResultListType.SearchResultListType_production.hashValue {
            let vc = PictureDetailViewController()
            vc.model = (searchResultView.dataSource[view][index] as! PictureModel)
            vc.isUpdatePicture = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else  if view == SearchResultListType.SearchResultListType_paint.hashValue {
            let layout = UICollectionViewFlowLayout.init()
            let vc = PicDetailCollectionViewController.init(collectionViewLayout: layout)
            vc.paintModel = (searchResultView.dataSource[view][index] as! PaintModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func cancelAction() {
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

class SearchCell: UICollectionViewCell {
    var titleLabel:UILabel!
    var isLayout:Bool = false
    func layoutUI() {
        if isLayout == false {
            isLayout = true
            titleLabel = UILabel.init(frame: self.bounds)
            titleLabel.font = xsFont(14)
            titleLabel.textColor = xsColor_main_yellow
            titleLabel.textAlignment = .center
            titleLabel.layer.borderColor = xsColor_main_yellow.cgColor
            titleLabel.layer.borderWidth = 1
            self.addSubview(titleLabel)
        }
        
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layoutUI()
        titleLabel.frame = self.bounds
    }
}

class SearchHeaderReuseableView: UICollectionReusableView {
    var titleLabel:UILabel!
    var clearButton:UIButton!
    var isLayout:Bool = false
    weak open var delegate:SearchProtocol!
    func layoutUI() {
        if isLayout == false {
            isLayout = true
            titleLabel = UILabel.init(frame: CGRect.init(x: 12, y: 0, width: self.width - 70, height: 40))
            titleLabel.font = xsFont(15)
            titleLabel.textColor = xsColor_main_text_blue
            titleLabel.textAlignment = .left
            self.addSubview(titleLabel)
            
            clearButton = UIButton.init(frame: CGRect.init(x: titleLabel.right, y: 0, width: 40, height: 40))
            clearButton.setImage(#imageLiteral(resourceName: "04s_shousuo_shanchu"), for: .normal)
            clearButton.setImage(#imageLiteral(resourceName: "04s_shousuo_shanchu"), for: .highlighted)
            clearButton.addTarget(self, action: #selector(clearAllHistory), for: .touchUpInside)
            self.addSubview(clearButton)
        }
        
    }
    
    @objc func clearAllHistory() {
        let alert = UIAlertController.init(title: "确认删除全部历史记录？", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .default, handler: nil)
        let confirm = UIAlertAction.init(title: "确定", style: .default, handler: {[weak self](act) in
            self?.delegate.clearnUpHistory!()
        })
        alert.addAction(cancel)
        alert.addAction(confirm)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layoutUI()
        titleLabel.frame = CGRect.init(x: 12, y: 0, width: self.width - 70, height: 40)
        clearButton.x = titleLabel.right
    }
}

@objc protocol SearchProtocol:NSObjectProtocol {
    @objc optional func clearnUpHistory()
    @objc optional func searchResultDidChoosedCell(view:Int,_ index:Int)
    @objc optional func playAction()
    @objc optional func pushAction()
    @objc optional func collectAction()
    @objc optional func shareAction()
    @objc optional func picsStyleChangeAction(style:Int)
    @objc optional func backAction()
    @objc optional func chooseMainPicAction()
}
