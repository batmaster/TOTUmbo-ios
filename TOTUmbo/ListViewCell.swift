//
//  ListViewCell.swift
//  TOTUmbo
//
//  Created by batmaster on 8/25/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var labelProvince: UILabel!
    @IBOutlet weak var labelDevice: UILabel!
    @IBOutlet weak var labelIp: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDown: UILabel!
    @IBOutlet weak var labelElapse: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
