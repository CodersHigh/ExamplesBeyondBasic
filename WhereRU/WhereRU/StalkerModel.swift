//
//  StalkerModel.swift
//  WhereRU
//
//  Created by Abraham Park on 1/22/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//

import Foundation

class StalkerModel {
    var arrayResult:[Any] = []
    var closureUpdateUI:(() -> ())?
    
    func requestFriendsList() {
//        let stringURL = "http://z.ebadaq.com:45080/whereru/friendsList.php"
        let stringURL = "http://z.ebadaq.com:45072/friends"
        let url = URL(string: stringURL)!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url) { (d:Data?, res:URLResponse?, err:Error?) in
            do {
                self.arrayResult = try JSONSerialization.jsonObject(with: d!, options: .allowFragments) as! [Any]
                
                print(self.arrayResult)
                
                if let c = self.closureUpdateUI {
                    c()
                }
                
                
            } catch {}
        }
        task.resume()
    }
}
