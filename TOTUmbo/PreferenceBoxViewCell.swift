//
//  PreferenceBoxViewCell.swift
//  TOTUmbo
//
//  Created by batmaster on 8/28/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import UIKit

class PreferenceBoxViewCell: UITableViewCell {
    
    @IBOutlet weak var labelProvince: UILabel!
    @IBOutlet weak var switchEnable: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
