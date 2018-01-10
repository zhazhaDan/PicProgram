//
//  PicDetailHeaderStyle2View
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PicDetailHeaderStyle3View: UICollectionReusableView {

    @IBOutlet weak var picTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var autoPicImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    open weak var delegate: SearchProtocol!
    
    @IBOutlet weak var totalNumLabel: UILabel!
    @IBOutlet weak var eyeNumLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var backTopConstraint: NSLayoutConstraint!
    var segmentIndex:Int = 1
    @IBAction func playAction(_ sender: Any) {
        delegate.playAction!()
    }
    
    @IBAction func pushAction(_ sender: Any) {
        delegate.pushAction!()
    }
    
    @IBAction func collectAction(_ sender: UIButton) {
        delegate.collectAction!(view: sender)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        delegate.shareAction!()
    }
    
    @objc func picTapAction(_ sender: Any) {
        delegate.chooseMainPicAction!()
    }
    
    @IBAction func picChangeAction(_ sender: UISegmentedControl) {
        segmentIndex = sender.selectedSegmentIndex
        delegate.picsStyleChangeAction!(style: sender.selectedSegmentIndex)
    }
    
    @IBAction func backAction(_ sender: Any) {
        delegate.backAction!()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backTopConstraint.constant = StatusBarHeight
        self.updateConstraints()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(picTapAction(_ :)))
        self.autoPicImageView.addGestureRecognizer(tap)
    }
}
