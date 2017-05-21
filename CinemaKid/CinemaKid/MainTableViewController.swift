//
//  MainTableViewController.swift
//  CinemaKid
//
//  Created by Abraham Park on 11/29/16.
//  Copyright © 2016 ebadaq.com. All rights reserved.
//

import UIKit

class MainTableViewController : UITableViewController {
    let queueSub = OperationQueue()
    var modelCinema = CinemaModel()
    var modelPoster = PosterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.queueSub.maxConcurrentOperationCount = 1
        
        self.modelCinema.requestToServer()
        self.modelCinema.closureUpdateUI = { [unowned self] () -> () in
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelCinema.arrayResult.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        var dicTemp = self.modelCinema.arrayResult[indexPath.row]
        var dicInfo = dicTemp as! Dictionary<String,String>
        
        cell.textLabel?.text = dicInfo["title"]
        cell.detailTextLabel?.text
            = "\(dicInfo["genre"]), \(dicInfo["runningTime"]) 분"
        
        cell.imageView?.image = UIImage(named: "loading.png")
        
        if let posterCode = dicInfo["posterCode"] {
            self.modelPoster.requestPoster(posterCode, afterUpdate: { (dataImage:Data?) in
                if let data = dataImage {
                    cell.imageView?.image = UIImage(data: data)
                }
            })
        }
        
        
//        let stringURL = "http://z.ebadaq.com:45070/CinemaKid/movie/stillcut/\(dicInfo["posterCode"]!)"
//        let url = URL(string: stringURL)!
//        self.queueSub.addOperation({ Void -> Void in
//            do {
//            let data = try Data(contentsOf: url)
//            
//                OperationQueue.main.addOperation({ 
//                    cell.imageView?.image = UIImage.init(data: data)
//                })
//            } catch {}
//            })
        
        
        return cell
    }
}















