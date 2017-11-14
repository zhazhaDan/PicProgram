//
//  ArtHeaderView.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/10/26.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit

class ArtHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    open weak var delegate:FindViewProtocol!
    @IBAction func nextAction(_ sender: Any) {
        delegate.seeMoreReaders!()
    }
    
}
