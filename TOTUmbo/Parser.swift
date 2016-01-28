//
//  Parser.swift
//  TOTUmbo
//
//  Created by batmaster on 8/24/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import Foundation

class Parser {
    
    class func Parse(var str: NSString) -> NSData {
        if (str == " ") {
            str = "Array\n(\n    [node_name] => \n)\n "
        }
        
        str = str.stringByReplacingOccurrencesOfString("\n", withString: "!!!")
        str = str.stringByReplacingOccurrencesOfString("Array!!!(!!!    [", withString: "{\"")
        str = str.stringByReplacingOccurrencesOfString("] => ", withString: "\":\"")
        str = str.stringByReplacingOccurrencesOfString("!!!    [", withString: "\",\"")
        str = str.stringByReplacingOccurrencesOfString("!!!)!!!", withString: "\"},")
        str = str.stringByReplacingOccurrencesOfString("!!!", withString: "")
        str = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        str = str.substringToIndex(str.length - 1)
        str = "[\(str)]"
        str = str.stringByReplacingOccurrencesOfString("[Optional({", withString: "[{")
        str = str.stringByReplacingOccurrencesOfString("})]", withString: "}]")
        
        return str.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}