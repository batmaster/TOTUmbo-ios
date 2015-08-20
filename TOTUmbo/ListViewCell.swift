//
//  ListViewCell.swift
//  TOTUmbo
//
//  Created by batmaster on 8/3/2558 BE.
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
    
//    init(style: UITableViewCellStyle, reuseIdentifier: String) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
