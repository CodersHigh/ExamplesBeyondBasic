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
typealias UpdateFunction = () -> Void



class APODData {
    let apodBaseURL = "https://api.nasa.gov/planetary/apod?api_key=MTg0aQMxj8DgcGsoEplsm2wW9SmmKpegOWNUrob4&date="
    
    var apodDictionary:[String:APOD] = [:]
    
    func fetchToday(_ completion:UpdateFunction){
        let apod = apodOfDay(dateString(Date()))
        completion()
    }
    
    func fetch(_ days:Int, _ completion:UpdateFunction){
        let dateArray:[Int] = Array(0 ... (days-1))
        let apods = dateArray.map{dateBehind($0)}.map{dateString($0)}.map{
            apodOfDay($0)
            completion()
        }
    }
    
    
    func apodOfDay(_ dateString:String) -> APOD? {
        if let existAPOD = apodDictionary[dateString] {
            return existAPOD
        }
        
        let dateURL = URL(string: (apodBaseURL + dateString))
        do {
            let apodData = try Data(contentsOf:dateURL!)
            let apodJSON = try JSONSerialization.jsonObject(with: apodData, options: []) as! [String:AnyObject]
            
            let imagePath:String = apodJSON["url"] as! String
            let imageData = try Data(contentsOf:URL(string:imagePath)!)
            let image = UIImage(data: imageData)
            
            let apodTitle = apodJSON["title"] as! String
            let apodDate = apodJSON["date"] as! String
            let apodExplanation = apodJSON["explanation"] as! String
            
            let apod = APOD(title:apodTitle, date:apodDate, explanation:apodExplanation, image:image!)
            
            apodDictionary[dateString] = apod
            return apod
        } catch { return nil }
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
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
}
