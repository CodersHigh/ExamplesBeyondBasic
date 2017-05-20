import Foundation
import UIKit
import CoreLocation

class UpdateModel : NSObject, CLLocationManagerDelegate {
    let stringUDID:String = UIDevice.current.identifierForVendor!.uuidString
    var latitude:CLLocationDegrees = 0.0
    var longitude:CLLocationDegrees = 0.0
    var stringMsg:String = ""
    var pushToken:String = "" // push token
    var pushOn:Bool = true
    
    let managerLocation = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            self.latitude = loc.coordinate.latitude
            self.longitude = loc.coordinate.longitude
            self.requestUpdate()
        }
    }
    
    override init() {
        super.init()
        self.managerLocation.delegate = self
    }
    
    func requestUpdate() {
        let stringURL = "http://z.ebadaq.com:45072/friends/updateMyInfo"
        let url:URL! = URL(string: stringURL)
        var request = URLRequest(url: url)
        
        let stringToSend = "deviceID=\(stringUDID)&latitude=\(latitude)&longitude=\(longitude)&message=\(stringMsg)"
        
        request.httpBody = stringToSend.data(using: .utf8)
        request.httpMethod = "POST"
        
        let urlConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: urlConfig)
        
        let task = session.dataTask(with: request) {
            (d:Data?, res:URLResponse?, err:Error?) in
            if let result = d {
                print("received : \(String(data:result, encoding: .utf8))")
            }
        }
        task.resume()
        
//        do {
//            let stringResult = try String(contentsOf: url,
//                                          encoding: .utf8)
//            print(stringResult)
//        } catch {}
        
    }
    
    func startLocationService() {
        self.managerLocation.requestAlwaysAuthorization()
        self.managerLocation.startUpdatingLocation()
    }
    
    func stopLocationService() {
        self.managerLocation.stopUpdatingLocation()
    }
}











