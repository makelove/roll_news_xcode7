//
//  NewsController.swift
//  sohu_roll_news
//
//  Created by WORK on 15/6/16.
//  Copyright © 2015年 洪国. All rights reserved.
//

import UIKit

class NewsController: UITableViewController ,UISearchBarDelegate{

    
    var tableData:NSMutableArray=NSMutableArray()
    // 加载更多 状态 风火轮
    var _aiv:UIActivityIndicatorView!
//    var count=0
    var refreshc:UIRefreshControl = UIRefreshControl()
    let host:String="http://192.168.7.135:5000"
    let url:String="http://192.168.7.135:5000/news"
    var limit=1
    
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearch:Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refresh(url)
        
        
        // 加载更多按扭的背景视图
        let tableFooterView:UIView = UIView()
        tableFooterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44)
        tableFooterView.backgroundColor = UIColor.greenColor()
        self.tableView.tableFooterView = tableFooterView
        
        refreshc.addTarget(self, action: "refreshcc", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshc)
        
        
        // 加载更多的按扭
        let loadMoreBtn = UIButton()
        loadMoreBtn.frame = CGRectMake(0, 0, self.view.bounds.width, 44)
        loadMoreBtn.setTitle("Load More", forState: .Normal)
        loadMoreBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        loadMoreBtn.addTarget(self, action: "loadMore:", forControlEvents: .TouchUpInside)
        tableFooterView.addSubview(loadMoreBtn)
        
        // 加载更多 状态 风火轮
        _aiv = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        _aiv.center = loadMoreBtn.center
        tableFooterView.addSubview(_aiv)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    //单元格设置
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let index = indexPath.row
        
//        cell.textLabel!.text = list[index]
        
        //获取cell的数据
        let rowData:NSDictionary=self.tableData[index] as! NSDictionary
//        print(rowData)
//        print(rowData["title"])
//        print(rowData["link"])
        //设置标题
         let title1  = rowData["title"] as! NSArray
//        print(title1)
//        print(title1[0] )
        cell.textLabel!.text = title1[0] as? String
//        print(cell.textLabel!.text)
        //设置详情
        let type :String = (rowData["type"] as! NSArray)[0] as! String
//        print(type)
        let time:String = (rowData["time"] as! NSArray )[0] as! String
        let link :String = (rowData["link"] as! NSArray )[0] as! String
        let detailLabel:String = time+","+type+","+link
        cell.detailTextLabel?.text = detailLabel
        return cell
    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        print("didDeselectRowAtIndexPath")
////        performSegueWithIdentifier("show", sender:indexPath.row)
//    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("show", sender:indexPath.row)
    }

    //推送note到详细页
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
            let destination: DetailController = segue.destinationViewController as! DetailController
            
            if sender is Int {
                //获取cell的数据
                let rowData:NSDictionary=self.tableData[sender as! Int] as! NSDictionary
                let note = (rowData["link"] as! NSArray )[0] as! String
                let title1 = (rowData["title"] as! NSArray )[0] as! String
                
                destination.urlstr = note
                destination.text = title1
            }
        }
    }
    
    func refreshcc(){
        if isSearch {
            limit=20
            self.tableData.removeAllObjects()
            isSearch=false
            searchBar.text=""
        }
        let count=tableData.count
        let url=self.url+"?offset=\(count)&limit=\(limit)"
        refresh(url)

        tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
        refreshc.endRefreshing()

    }
    

    func refresh(url:String){
        do{
            let rs = try SynchonousRequest(url)
//            print("rs:\(rs)")
            if(rs.count>0){
                //            println(results["mails"])
                
                //填充tableData
                
                self.tableData.addObjectsFromArray(rs as [AnyObject])
//                count += rs.count
            }
        }catch{
            print(error)
        }
    }
    func SynchonousRequest(url1:String)throws ->NSArray {
        let urlPath: String = url1.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        //        var error: NSErrorPointer = nil
        let dataVal: NSData =  try! NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
        //        var err: NSError
        //        println(response)
//        let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        //        println("Synchronous\(jsonResult)")
        return jsonResult
    }
   
    // 加载更多方法
    func loadMore(sender:UIButton) {
        
        sender.hidden = true
        _aiv.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            
                           print("Load more")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                sleep(1)
                
                self._aiv.stopAnimating()
                sender.hidden = false
                
                self.tableView.reloadData()
            })
        })
    }
    
    //Search
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        //搜索状态设为true
//        isSearch = false
        //清空搜索条文本
        searchBar.text=""
        //关闭虚拟键盘
        searchBar.resignFirstResponder()

    }
    
    //响应虚拟键盘上的search按钮
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("search button")
        onSearch(searchBar.text!)
        searchBar.resignFirstResponder()
    }
    
    //搜索函数
    func onSearch(str:String){
        //搜索状态设为true
        isSearch = true
        
        let searchUrl=host+"/search?kw="+str+"&limit=\(20)&offset=0"
        print(searchUrl)
        
        do{
            let rs = try SynchonousRequest(searchUrl)
            //            print("rs:\(rs)")
            if(rs.count>0){
                //            println(results["mails"])
                
                //填充tableData
                self.tableData.removeAllObjects()
                self.tableData.addObjectsFromArray(rs as [AnyObject])
                //                count += rs.count
            }
        }catch{
            print(error)
        }

        
        self.tableView.reloadData()
    }

}
