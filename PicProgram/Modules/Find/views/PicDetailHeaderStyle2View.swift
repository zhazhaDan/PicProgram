//
//  PicDetailHeaderStyle2View
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/23.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class PicDetailHeaderStyle2View: UICollectionReusableView {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var autoPicImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    open weak var delegate: SearchProtocol!
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
    @IBAction func picChangeAction(_ sender: UISegmentedControl) {
        delegate.picsStyleChangeAction!(style: sender.tag)
    }
    @IBAction func backAction(_ sender: Any) {
        delegate.backAction!()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
