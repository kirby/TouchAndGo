//
//  ButtonCollectionViewCell.swift
//  TouchAndGo
//
//  Created by Kirby Shabaga on 11/5/16.
//  Copyright © 2016 Kirby Shabaga. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var liveButton = false
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPress)))
    }
    
    func longPress(gesture: UILongPressGestureRecognizer) {
        
        if (!liveButton) {
            return
        }
        
        let target = gesture.view!
        
        let backgroundColor = target.backgroundColor
        
        switch gesture.state {
            
            case .began:
                OperationQueue.main.addOperation({ () -> Void in
                    self.backgroundColor = UIColor.blue
                })
            
            case .ended:
                self.postRequest(serviceRequest: false)
                OperationQueue.main.addOperation({ () -> Void in
                    self.backgroundColor = backgroundColor
                })
                
                break
            default: break
        }
    }
    
    func postRequest(serviceRequest: Bool)
    {
        let url:NSURL = NSURL(string: "http://touchandgo.ngrok.io/serviceRequested")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        let params = [ "serviceRequested": false ]
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch {
            print("error")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("postRequest response = \(dataString!)")
            
            OperationQueue.main.addOperation({ () -> Void in
                self.backgroundColor = UIColor.green
            })
            
        }
        
        task.resume()
        
    }
    
}
