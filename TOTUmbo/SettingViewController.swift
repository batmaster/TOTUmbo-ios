//
//  SettingViewController.swift
//  TOTUmbo
//
//  Created by batmaster on 8/26/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var listView: UITableView!
    
    var listViewDataSource: NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !SharedValues.hasEnableStatePref("notification", isProvince: false){
            SharedValues.setEnableStatePref("notification", value: false, isProvince: false)
        }
        
        switchNotification.on = SharedValues.getEnableStatePref("notification", isProvince: false)

        listView.dataSource = self
        listView.delegate = self
        
        getProvincesTask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchNotificationClicked(sender: UISwitch) {
        SharedValues.setEnableStatePref("notification", value: sender.on, isProvince: false)
    }
    
    @IBAction func switchClicked(sender: UISwitch) {
        SharedValues.setEnableStatePref((listViewDataSource[sender.tag] as! PreferenceBoxViewItem).province, value: sender.on, isProvince: true)
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PreferenceBoxCell", forIndexPath: indexPath) as! PreferenceBoxViewCell
        
        let province: String = (listViewDataSource[indexPath.row] as! PreferenceBoxViewItem).province
        let enable: Bool = (listViewDataSource[indexPath.row] as! PreferenceBoxViewItem).enable
        
        
        cell.labelProvince.text = province
        cell.labelProvince.font = UIFont.boldSystemFontOfSize(17.0)
        
        cell.switchEnable.tag = indexPath.row
        cell.switchEnable.setOn(enable, animated: false)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PreferenceBoxViewCell
        cell.switchEnable.setOn(!cell.switchEnable.on, animated: true)
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
                        if !SharedValues.hasEnableStatePref(province, isProvince: true) {
                            SharedValues.setEnableStatePref(province, value: false, isProvince: true)
                        }
                        let enable = SharedValues.getEnableStatePref(province, isProvince: true)
                        
                        self.listViewDataSource.addObject(PreferenceBoxViewItem(province: province, enable: enable))
                    }
                } else {
                    print("Failed...")
                }
            } catch let serializationError as NSError {
                print(serializationError)
            }
            
            self.listView.performSelectorOnMainThread(Selector("reloadData"), withObject: nil, waitUntilDone: true)
        })
        task.resume()
    }
    
    
    
    
}
