//
//  APNSTableViewController.swift
//  WhereRU
//
//  Created by Abraham Park on 5/20/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//

import UIKit
import UserNotifications

class APNSTableViewController: UITableViewController {
    let modelPushTest = PushTestModel()
    
    @IBAction func touchDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:  // regist Device
            self.procRegist() // 등록 시도.
            break
        case 1:
            self.procTestPush()
            break
        default:
            break
        }
    }
    
    func procRegist(){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                UIApplication.shared.registerForRemoteNotifications()
                
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings()
            
            UIApplication.shared.registerUserNotificationSettings(settings)
            
            UIApplication.shared.registerForRemoteNotifications()            
        }
    }
    
    func procTestPush(){
        self.modelPushTest.requestPushToAll()
    }

}
