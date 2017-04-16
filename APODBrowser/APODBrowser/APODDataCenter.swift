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

typealias APOD = (title:String, date:String, explanation:String, image:UIImage)

class APODData {
    let apodBaseURL = "https://api.nasa.gov/planetary/apod?api_key=MTg0aQMxj8DgcGsoEplsm2wW9SmmKpegOWNUrob4&date="
    
    var apodList:[APOD] = []
    
    init(){
        let todayURL = URL(string: (apodBaseURL + dateString(Date())))
        do {
            let apodData = try Data(contentsOf:todayURL!)
            let apodJSON = try JSONSerialization.jsonObject(with: apodData, options: []) as! [String:AnyObject]
        
            let imagePath:String = apodJSON["hdurl"] as! String
            let imageData = try Data(contentsOf:URL(string:imagePath)!)
            let image = UIImage(data: imageData)
            
            let apodTitle = apodJSON["title"] as! String
            let apodDate = apodJSON["date"] as! String
            let apodExplanation = apodJSON["explanation"] as! String
            
            apodList.append(APOD(title:apodTitle, date:apodDate, explanation:apodExplanation, image:image!))
            
            //print(apodJSON)
        } catch {}
    }
    
    
    func dateBehind(_ days:Int) -> Date {
        let interval = TimeInterval(24 * 60 * 60 * days)
        return Date(timeIntervalSinceNow: -interval)
    }
    
    func dateString(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
}
