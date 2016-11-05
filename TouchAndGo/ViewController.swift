//
//  ViewController.swift
//  TouchAndGo
//
//  Created by Kirby Shabaga on 11/5/16.
//  Copyright © 2016 Kirby Shabaga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var serviceRequestedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Define identifier
        let notificationName = Notification.Name("serviceRequested")

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getServiceRequested(withNotification:)), name:notificationName, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getServiceRequested(withNotification : NSNotification) {
//        print(withNotification.userInfo as Any)
        
        let serviceRequested = withNotification.object as! Bool
        
        print("serviceRequested = \(serviceRequested)")
        
        if (serviceRequested) {
            self.serviceRequestedView.backgroundColor = UIColor.red
        } else {
            self.serviceRequestedView.backgroundColor = UIColor.green
        }
    }

}
