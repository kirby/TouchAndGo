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
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPress)))
    }
    
    func longPress(gesture: UILongPressGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
            case .changed:
//                target.backgroundColor = UIColor.blue
                self.postRequest()
                
                break
            default: break
        }
    }
    
    func postRequest()
    {
        let url:NSURL = NSURL(string: "http://localhost:1880/touchAndGo")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
//        let params = "serviceRequested=false"
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
            print(dataString!)
            
        }
        
        task.resume()
        
    }
    
}
