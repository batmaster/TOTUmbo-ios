//
//  ViewController.swift
//  TOTUmbo
//
//  Created by batmaster on 7/20/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import UIKit

class DownViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var pickerViewProvinces: UIPickerView!
    @IBOutlet weak var listView: UITableView!
    
    var pickerDataSource: NSMutableArray = ["a"]
    var listViewDataSource: NSMutableArray = ["b"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewProvinces.dataSource = self
        pickerViewProvinces.delegate = self
        
        listView.dataSource = self
        listView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerDataSource[row] as! String
        let myTitle = NSAttributedString(string: titleData)
        pickerLabel.attributedText = myTitle
        return pickerLabel
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = listViewDataSource[row] as? String
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(listViewDataSource[row])
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
            
//                        print("\n\n\n\(str!)\n\n\n")
            
            let nsdata = str!.dataUsingEncoding(NSUTF8StringEncoding)
            
//            var jsonError: NSError?
//            let jsonDict: NSArray = (NSJSONSerialization.JSONObjectWithData(nsdata!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSArray)!
//            
//            
//            for json in jsonDict {
//                let province = json.valueForKey("province") as! String
//                let amount = json.valueForKey("amount") as! String
//                
//                print("ss \(province) \(amount)")
//                self.pickerDataSource.addObject("\(province)\t\t\(amount)")
//            }
            
            
            do {
                if let jsonDict: NSArray = try! NSJSONSerialization.JSONObjectWithData(nsdata!, options:NSJSONReadingOptions.MutableContainers) as? NSArray {
                
                    for json in jsonDict {
                        let province = json.valueForKey("province") as! String
                        let amount = json.valueForKey("amount") as! String
                        
                        print("ss \(province) \(amount)")
                        self.pickerDataSource.addObject("\(province)\t\t\(amount)")
                    }
                } else {
                    print("Failed...")
                }
            } catch let serializationError as NSError {
                print(serializationError)
            }
            
            
                
                //              print(jsonDict)
            
            self.pickerViewProvinces.reloadAllComponents()
            
            
        })
        
        task.resume()
    }
    @IBAction func req(sender: AnyObject) {
        request("SELECT s.province AS province, SUM(CASE WHEN smsdown = 'yes' AND smsup = '' THEN 1 ELSE 0 END) AS amount FROM sector s, nodeumbo n WHERE n.node_sector = s.umbo GROUP BY s.province ORDER BY s.province")
        
        JLToast.makeText("Simple Toast Message").show()

    }
}

