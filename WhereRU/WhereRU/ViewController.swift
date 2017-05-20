//
//  ViewController.swift
//  WhereRU
//
//  Created by Abraham Park on 1/20/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var textFieldMessage:UITextField!
    @IBOutlet var constraintBottom:NSLayoutConstraint!
    @IBOutlet weak var viewMap: MKMapView!
    @IBOutlet weak var switchLocation: UISwitch!
    
    var modelUpdate = UpdateModel()
    var modelStaker = StalkerModel()
    
    @IBAction func touchSend(){
        self.modelUpdate.stringMsg = self.textFieldMessage.text!
        
        self.textFieldMessage.text = nil
        
        self.modelUpdate.requestUpdate()
        
        self.textFieldMessage.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchLocation.setOn(false, animated: true)
        
//        self.modelUpdate.requestUpdate()
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIKeyboardDidShow ,
            object: nil,
            queue: nil) { (n:Notification) in
                let dicInfo = n.userInfo!
                let frame = dicInfo[UIKeyboardFrameBeginUserInfoKey] as! CGRect
                
                self.constraintBottom.constant = frame.size.height + 10.0;
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIKeyboardDidHide ,
            object: nil,
            queue: nil) { (n:Notification) in
                self.constraintBottom.constant = 20.0;
        }
        
        self.modelStaker.requestFriendsList()
        self.modelStaker.closureUpdateUI = {
            OperationQueue.main.addOperation {[unowned self] in
                self.updatePin()
            }
            
        }
    }
    
    func updatePin() {
        for info in self.modelStaker.arrayResult {
            let dicInfo = info as! [String:Any]
            
            var lati:Double = 0
            let strLati = dicInfo["latitude"] as? String
            
            if let l = strLati {
                lati = Double(l)!
            }
            
            var longi:Double = 0
            let strLongi = dicInfo["longitude"] as? String
            
            if let l = strLongi {
                longi = Double(l)!
            }
            
            let msg = dicInfo["message"] as? String
            
            let pin = MyPin(latitude: lati, longitude: longi, message: msg)
            
            self.viewMap.addAnnotation(pin)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchSMF(_ sender: Any) {
        let coor = self.viewMap.centerCoordinate;
        
        self.modelUpdate.latitude = coor.latitude
        self.modelUpdate.longitude = coor.longitude
        
        self.modelUpdate.requestUpdate()
    }
    
    @IBAction func touchAutoLocation(_ sender: Any) {
        let flag = (sender as! UISwitch).isOn
        
        if flag == true{
            self.modelUpdate.startLocationService()
        }
        else{
            self.modelUpdate.stopLocationService()
        }
    }

}
















