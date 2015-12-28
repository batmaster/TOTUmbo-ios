//
//  NotificationViewController.swift
//  TOTUmbo
//
//  Created by batmaster on 8/26/2558 BE.
//  Copyright © 2558 batmaster. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    
    var listViewDataSource: NSMutableArray = []
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        
        leftSwipe.direction = .Left
        
        
        view.addGestureRecognizer(leftSwipe)
        
        
        
        listView.dataSource = self
        listView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "ลากลงเพื่อรีเฟรช")
        refreshControl.addTarget(self, action: "getDownListTask", forControlEvents: UIControlEvents.ValueChanged)
        listView.addSubview(refreshControl)
        
        getDownListTask()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("DownView") as! UIViewController
            self.presentViewController(vc, animated: false, completion: nil)
            
        }
        
        if (sender.direction == .Right) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SettingView") as! UIViewController
            self.presentViewController(vc, animated: false, completion: nil)
        }
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
        cell.labelProvince.hidden = !(listViewDataSource[indexPath.row] as! ListViewItem).showProvince
        
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
        
        if ((listViewDataSource[indexPath.row] as! ListViewItem).device == "ไม่มีรายการ") {
            cell.labelProvince.hidden = true
            cell.labelIp.hidden = true
            cell.labelTemp.hidden = true
            cell.labelDate.hidden = true
            cell.labelDown.hidden = true
            cell.labelElapse.hidden = true
        }
        else {
            cell.labelIp.hidden = false
            cell.labelTemp.hidden = false
            cell.labelDate.hidden = false
            cell.labelDown.hidden = false
            cell.labelElapse.hidden = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
    }
    
    func getDownListTask() {
        let url = NSURL(string: SharedValues.HOST_DB)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        var sql = SharedValues.REQ_GET_DOWNLIST(SharedValues.getEnableProvinces())
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
                    
                    self.listViewDataSource.removeAllObjects()
                    
                    for json in jsonDict {
                        let device = json.valueForKey("node_name") as! String
                        if (device == "") {
                            self.listViewDataSource.addObject(ListViewItem(province: "", device: "ไม่มีรายการ", ip: "", temp: "", date: "", elapse: "", showProvince: false))
                            break;
                        }
                        let province = json.valueForKey("province") as! String
                        let ip = json.valueForKey("node_ip") as! String
                        let temp = json.valueForKey("temp") as! String
                        
                        let dateString = json.valueForKey("node_time_down") as! String
                        let dateDate = NSDate(timeIntervalSince1970: (dateString as NSString).doubleValue)
                        let formatter = NSDateFormatter()
                        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
                        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 7)
                        let date = formatter.stringFromDate(dateDate)
                        
                        let elapse = NSDate().offsetFrom(dateDate)
                        
                        self.listViewDataSource.addObject(ListViewItem(province: province, device: device, ip: ip, temp: temp, date: date, elapse: elapse, showProvince: true))
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
