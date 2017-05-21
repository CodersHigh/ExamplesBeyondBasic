//
//  CinemaModel.swift
//  CinemaKid
//
//  Created by Abraham Park on 11/29/16.
//  Copyright © 2016 ebadaq.com. All rights reserved.
//
import UIKit
import Foundation

class CinemaModel: NSObject {
    var arrayResult:Array<AnyObject> = []
    var closureUpdateUI:(() -> ())?
    
    func requestToServer(){
        let stringURL = "http://z.ebadaq.com:45070/CinemaKid/movie/list/"
        //let stringURL = "http://192.168.197.138/CinemaKid/movie/list/"
        let url = URL(string: stringURL)!
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        let task = session.dataTask(with: request,
                                    completionHandler: {(data:Data?, resp:URLResponse?, err:Error?) -> Void
            in
            //print(String(data: data!, encoding:String.Encoding.utf8)!)
            do{
               let result = try JSONSerialization.jsonObject(with: data!,
                                                    options: .allowFragments)
                var temp = result as! Dictionary<String,AnyObject>
                
                self.arrayResult = temp["data"] as! Array<AnyObject>
                
                if let updateUI = self.closureUpdateUI {
                    OperationQueue.main.addOperation({ Void -> Void in
                        updateUI()
                    })
                    
                }
                
//                (((UIApplication.shared.delegate as! AppDelegate).window!.rootViewController as! UINavigationController).viewControllers.last as! MainTableViewController).tableView.reloadData()
                
            }catch{
                
                                        }
    })
        task.resume()
    }
}

















