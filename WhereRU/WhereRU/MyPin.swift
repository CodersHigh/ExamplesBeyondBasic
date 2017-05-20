//
//  MyPin.swift
//  WhereRU
//
//  Created by Abraham Park on 5/20/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//

import UIKit
import MapKit

class MyPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(latitude:CLLocationDegrees, longitude:CLLocationDegrees, message:String?){
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = message
    }
}
