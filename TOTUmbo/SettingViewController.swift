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
    
    let pref = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.pref.objectForKey("notification") == nil {
            self.pref.setBool(false, forKey: "notification")
        }
        let notificationEnable = self.pref.boolForKey("notification")
        switchNotification.on = notificationEnable

        listView.dataSource = self
        listView.delegate = self
        
        getProvincesTask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchNotificationClicked(sender: UISwitch) {
        self.pref.setBool(sender.on, forKey: "notification")
    }
    
    @IBAction func switchClicked(sender: UISwitch) {
        self.pref.setBool(sender.on, forKey: (listViewDataSource[sender.tag] as! PreferenceBoxViewItem).province)
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
                        if self.pref.objectForKey(province) == nil {
                            self.pref.setBool(false, forKey: province)
                        }
                        let enable = self.pref.boolForKey(province)
                        
                        self.listViewDataSource.addObject(PreferenceBoxViewItem(province: province, enable: enable))
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
