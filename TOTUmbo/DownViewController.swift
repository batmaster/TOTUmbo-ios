//
//  ViewController.swift
//  TOTUmbo
//
//  Created by batmaster on 7/20/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerViewProvinces: UIPickerView!
    
    var pickerDataSource: NSMutableArray = ["a"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewProvinces.dataSource = self;
        pickerViewProvinces.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerDataSource[row] as! String
        let myTitle = NSAttributedString(string: titleData)
        pickerLabel.attributedText = myTitle
        return pickerLabel
    }
    
    func request(sqlstatement: String) {
        
        let url = NSURL(string: "http://203.114.104.242/umbo/getRecord.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        var sql = sqlstatement
        sql = sql.stringByReplacingOccurrencesOfString("'", withString: "xxaxx")
        sql = sql.stringByReplacingOccurrencesOfString("(", withString: "xxbxx")
        sql = sql.stringByReplacingOccurrencesOfString(")", withString: "xxcxx")
        sql = sql.stringByReplacingOccurrencesOfString(">", withString: "xxdxx")
        let param: String = "sql=\(sql)"
        
        request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            
            //            if error != nil {
            //                print(" ***error = \(error)")
            //                return
            //            }
            //
            //            print("*** response = \(response)")
            //
            //            var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //            print("*** data = \(str)")
            
            var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            str = str!.stringByReplacingOccurrencesOfString("\n", withString: "!!!")
            str = str!.stringByReplacingOccurrencesOfString("Array!!!(!!!    [", withString: "{\"")
            str = str!.stringByReplacingOccurrencesOfString("] => ", withString: "\":\"")
            str = str!.stringByReplacingOccurrencesOfString("!!!    [", withString: "\",\"")
            str = str!.stringByReplacingOccurrencesOfString("!!!)!!!", withString: "\"},")
            str = str!.stringByReplacingOccurrencesOfString("!!!", withString: "")
            str = str!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            str = str!.substringToIndex(str!.length - 1)
            str = "[\(str)]"
            str = str!.stringByReplacingOccurrencesOfString("[Optional({", withString: "[{")
            str = str!.stringByReplacingOccurrencesOfString("})]", withString: "}]")
            
//                        print("\n\n\n\(str!)\n\n\n");
            
            let nsdata = str!.dataUsingEncoding(NSUTF8StringEncoding)
            
            do {
                let jsonDict: NSArray = try (NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers) as? NSArray)!
                
                
                for json in jsonDict {
                    let province = json.valueForKey("province") as! String
                    let amount = json.valueForKey("amount") as! String
                    
                    print("ss \(province) \(amount)")
                    self.pickerDataSource.addObject("\(province)\t\t\(amount)")
                }
                
                
                //              print(jsonDict)
            } catch let error as NSError {
                print(error)
            } catch {
                print("error")
            }
            
            self.pickerViewProvinces.reloadAllComponents()
            
            
        })
        
        task!.resume()
    }
    
    @IBAction func test(sender: AnyObject) {
        //        request("SELECT * FROM nodeumbo LIMIT 2")
        request("SELECT s.province AS province, SUM(CASE WHEN smsdown = 'yes' AND smsup = '' THEN 1 ELSE 0 END) AS amount FROM sector s, nodeumbo n WHERE n.node_sector = s.umbo GROUP BY s.province ORDER BY s.province")
    }
}

