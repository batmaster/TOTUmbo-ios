//
//  ListViewItem.swift
//  TOTUmbo
//
//  Created by batmaster on 8/25/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import Foundation

class ListViewItem {
    var province: String
    var device: String
    var ip: String
    var temp: String
    var date: String
    var elapse: String
    
    var showProvince: Bool
    
    init(province: String, device: String, ip: String, temp: String, date: String, elapse: String, showProvince: Bool) {
        self.province = province
        self.device = device
        self.ip = ip
        self.temp = temp
        self.date = date
        self.elapse = elapse
        self.showProvince = showProvince
    }
}
