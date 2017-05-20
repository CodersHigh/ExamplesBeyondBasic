//
//  PushTestModel.swift
//  WhereRU
//
//  Created by Abraham Park on 5/20/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//

import Foundation

class PushTestModel {
    
    func requestPushToAll() {
        let stringURL = "http://z.ebadaq.com:45072/friends/pushToAll"
        let url = URL(string: stringURL)!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url) { (d:Data?, res:URLResponse?, err:Error?) in
            do {
            } catch {}
        }
        task.resume()
    }
}
