//
//  DetailController.swift
//  sohu_roll_news
//
//  Created by WORK on 15/6/16.
//  Copyright © 2015年 洪国. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

//    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var web: UIWebView!
    var urlstr:String!
    var text:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("text:\(text)")
//        //        label.text = text as? String
//        
//        if text != nil {
//            label1.text = text
//        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
//        print("text:\(text)")
//        label.text = text as? String
        
        if urlstr != nil {
//            label1.text = text
//            let urlstr = text as String
            let url=NSURL(string: urlstr)
            let urlRequest=NSURLRequest(URL: url!)
            web.loadRequest(urlRequest)
        }
        if text != nil{
            self.title=text
        }
    }
    

   
}
