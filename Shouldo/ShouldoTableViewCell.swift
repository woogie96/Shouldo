//
//  ShouldoTableViewCell.swift
//  Shouldo
//
//  Created by woogie on 20/05/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit

class ShouldoTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var isFinishedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
