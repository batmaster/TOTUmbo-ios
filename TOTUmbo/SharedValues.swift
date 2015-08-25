//
//  SharedValues.swift
//  TOTUmbo
//
//  Created by batmaster on 7/24/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import Foundation

class SharedValues {
    
    static let HOST_DB: String = "http://203.114.104.242/umbo/getRecord.php"
    
    class func REQ_GET_PROVINCES() -> String {
        return "SELECT s.province AS province, SUM(CASE WHEN smsdown = 'yes' AND smsup = '' THEN 1 ELSE 0 END) AS amount FROM sector s, nodeumbo n WHERE n.node_sector = s.umbo GROUP BY s.province ORDER BY s.province"
    }
    
    class func REQ_GET_DOWNLIST(provincesArray: [String]) -> String {
        var i: Int = 0
        var provinces: String = ""
        for province in provincesArray {
            provinces += "'" + province + "'"
            if i != provincesArray.count - 1 {
                provinces += ","
            }
            
            i += 1
        }
        
        if provincesArray.count == 0 {
            provinces += "'z'"
        }
        
        return "SELECT n.*, s.province FROM nodeumbo n, sector s WHERE n.node_sector = s.umbo AND s.province IN (\(provinces)) AND smsdown = 'yes' AND smsup = '' ORDER BY n.id_nu DESC"
    }
    
    class func REQ_GET_UPLIST() -> String {
        return "SELECT n.*, s.province FROM nodeumbo n, sector s WHERE n.node_sector = s.umbo AND n.id_nu IN (%s) AND smsdown = 'yes' AND smsup = 'yes' ORDER BY n.id_nu DESC"
    }
}
