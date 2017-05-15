//
//  APODDataCenter.swift
//  APODBrowser
//
//  Created by Lingostar on 2017. 4. 16..
//  Copyright © 2017년 CodersHigh. All rights reserved.
//

import Foundation
import UIKit

let apodData = APODData()

typealias APOD = (title:String, date:String, explanation:String, image:UIImage?)
typealias UpdateFunction = () -> Void



class APODData {
    let apodBaseURL = "https://api.nasa.gov/planetary/apod?api_key=MTg0aQMxj8DgcGsoEplsm2wW9SmmKpegOWNUrob4&date="
    
    var apodDictionary:[String:APOD] = [:]
    let jsonQueue = OperationQueue()
    
    func fetch(_ days:Int, _ completion:@escaping UpdateFunction){
        let dateArray:[Int] = Array(0 ... (days-1))
        dateArray.map{dateBehind($0)}.map{dateString($0)}.map{date in
            jsonQueue.addOperation {
                self.apodOfDay(date, completion)
            }
        }
    }
    
    
    func apodOfDay(_ dateString:String, _ completion:@escaping UpdateFunction) -> APOD? {
        if let existAPOD = apodDictionary[dateString] {
            return existAPOD
        }
        
        var newAPOD:APOD?
        
        guard let dateURL = URL(string: (apodBaseURL + dateString)) else { return nil }
        let urlRequest = URLRequest(url:dateURL)
        
        let jsonSession = URLSession.shared
        let jsonTask = jsonSession.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> Void in
            do {
                let apodJSON = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                
                let imagePath:String = apodJSON["url"] as! String
                let imageData = try Data(contentsOf:URL(string:imagePath)!)
                let image = UIImage(data: imageData)
                
                let apodTitle = apodJSON["title"] as! String
                let apodDate = apodJSON["date"] as! String
                let apodExplanation = apodJSON["explanation"] as! String
                
                newAPOD = APOD(title:apodTitle, date:apodDate, explanation:apodExplanation, image:image)
                
                self.apodDictionary[dateString] = newAPOD
                
                OperationQueue.main.addOperation {
                    completion()
                }
                
            } catch { print("JSON Parsing Error") }
        })
        jsonTask.resume()
        
        return newAPOD
    }
    
    
    func apodAt(_ index:Int) -> APOD {
        let keyArray:[String] = Array(apodDictionary.keys)
        let keyString = keyArray[index]
        return apodDictionary[keyString]!
    }
    
    func dateBehind(_ days:Int) -> Date {
        let interval = TimeInterval(24 * 60 * 60 * days)
        return Date(timeIntervalSinceNow: -interval)
    }
    
    func dateString(_ date:Date) -> String {
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.init(identifier: "America/Los_Angeles")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
}
