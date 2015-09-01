//
//  ViewController.swift
//  TOTUmbo
//
//  Created by batmaster on 7/20/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

// JLToast.makeText("Simple Toast Message").show()

import UIKit

class DownViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var pickerViewProvinces: UIPickerView!
    @IBOutlet weak var listView: UITableView!
    
    var pickerDataSource: NSMutableArray = []
    var listViewDataSource: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewProvinces.dataSource = self
        pickerViewProvinces.delegate = self
        
        listView.dataSource = self
        listView.delegate = self
        
        getProvincesTask()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell", forIndexPath: indexPath) as! ListViewCell
        
        cell.labelProvince.text = (listViewDataSource[indexPath.row] as! ListViewItem).province
        cell.labelProvince.font = UIFont.boldSystemFontOfSize(17.0)
        cell.labelProvince.hidden = (listViewDataSource[indexPath.row] as! ListViewItem).showProvince
        
        cell.labelDevice.text = (listViewDataSource[indexPath.row] as! ListViewItem).device
        cell.labelDevice.font = UIFont.boldSystemFontOfSize(17.0)
        
        cell.labelIp.text = (listViewDataSource[indexPath.row] as! ListViewItem).ip
        cell.labelIp.sizeToFit()
        
        cell.labelTemp.text = (listViewDataSource[indexPath.row] as! ListViewItem).temp + "°C"
        cell.labelTemp.frame = CGRectMake(cell.labelIp.frame.width + 4, 0, 0, cell.labelIp.frame.height)
        cell.labelTemp.sizeToFit()
        
        cell.labelDate.text = (listViewDataSource[indexPath.row] as! ListViewItem).date
        cell.labelDate.sizeToFit()
        
        cell.labelElapse.text = (listViewDataSource[indexPath.row] as! ListViewItem).elapse
        cell.labelElapse.frame = CGRectMake(cell.labelDown.frame.width + 4, 0, 0, cell.labelDown.frame.height)
        cell.labelElapse.sizeToFit()
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(listViewDataSource[row])
    }
    
    
    
    
    
    
    
    
    func getProvincesTask() {
        let url = NSURL(string: SharedValues.HOST_DB)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        var sql = SharedValues.REQ_GET_PROVINCES()
        sql = sql.stringByReplacingOccurrencesOfString("'", withString: "xxaxx")
        sql = sql.stringByReplacingOccurrencesOfString("(", withString: "xxbxx")
        sql = sql.stringByReplacingOccurrencesOfString(")", withString: "xxcxx")
        sql = sql.stringByReplacingOccurrencesOfString(">", withString: "xxdxx")
        let param: String = "sql=\(sql)"
        
        request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            
            let nsdata = Parser.Parse(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            
            do {
                if let jsonDict: NSArray = try! NSJSONSerialization.JSONObjectWithData(nsdata, options:NSJSONReadingOptions.MutableContainers) as? NSArray {
                    
                    for json in jsonDict {
                        let province = json.valueForKey("province") as! String
                        let amount = json.valueForKey("amount") as! String
                        
                        self.pickerDataSource.addObject("\(province)\t\t\(amount)")
                    }
                } else {
                    print("Failed...")
                }
            } catch let serializationError as NSError {
                print(serializationError)
            }
            
            self.pickerViewProvinces.reloadAllComponents()
            
            self.getListTask()
        })
        task.resume()
    }
    
    func getListTask() {
        let url = NSURL(string: SharedValues.HOST_DB)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
//        let selectedProvince = pickerDataSource[pickerViewProvinces.selectedRowInComponent(0)].componentsSeparatedByString("\t")[0]
        let selectedProvince = "ตรัง"
        var sql = SharedValues.REQ_GET_DOWNLIST(["\(selectedProvince)"])
        sql = sql.stringByReplacingOccurrencesOfString("'", withString: "xxaxx")
        sql = sql.stringByReplacingOccurrencesOfString("(", withString: "xxbxx")
        sql = sql.stringByReplacingOccurrencesOfString(")", withString: "xxcxx")
        sql = sql.stringByReplacingOccurrencesOfString(">", withString: "xxdxx")
        let param: String = "sql=\(sql)"
        
        request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            
            let s = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let nsdata = Parser.Parse(s)
            
            do {
                if let jsonDict: NSArray = try! NSJSONSerialization.JSONObjectWithData(nsdata, options:NSJSONReadingOptions.MutableContainers) as? NSArray {
                    
//                    print(jsonDict)
                    
                    var i = 0
                    for json in jsonDict {
                        print(">>\(i)<<")
                        i += 1
                        let province = json.valueForKey("province") as! String
                        let device = json.valueForKey("node_name") as! String
                        let ip = json.valueForKey("node_ip") as! String
                        let temp = json.valueForKey("temp") as! String
                        
                        let dateString = json.valueForKey("node_time_down") as! String
                        let dateDate = NSDate(timeIntervalSince1970: (dateString as NSString).doubleValue)
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
                        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 7)
                        let date = formatter.stringFromDate(dateDate)
                        
                        let elapse = NSDate().offsetFrom(dateDate)
                        
                        self.listViewDataSource.addObject(ListViewItem(province: province, device: device, ip: ip, temp: temp, date: date, elapse: elapse, showProvince: false))
                    }
                } else {
                    print("Failed...")
                }
            } catch let serializationError as NSError {
                print(serializationError)
            }
            
            self.listView.reloadData()
        })
        task.resume()
    }
}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: NSCalendarOptions(rawValue: 0)).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
