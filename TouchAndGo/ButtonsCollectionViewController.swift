//
//  ButtonsCollectionViewController.swift
//  TouchAndGo
//
//  Created by Kirby Shabaga on 11/5/16.
//  Copyright © 2016 Kirby Shabaga. All rights reserved.
//

import UIKit

class ButtonsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // Define identifier
    let notificationName = Notification.Name("serviceRequested")
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ButtonCell"
    fileprivate let itemsPerRow: CGFloat = 2

    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var buttons = [ButtonStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
//        $color1: rgba(239, 118, 122, 1);  // red
//        $color2: rgba(69, 105, 144, 1);   // blue
//        $color3: rgba(73, 190, 170, 1);   // light green
//        $color4: rgba(73, 220, 177, 1);   // green
//        $color5: rgba(238, 184, 104, 1);  // yellow
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getServiceRequested(withNotification:)), name:notificationName, object: nil)
        
        self.buttons.append(ButtonStruct(floor: "1", location: "Men", locationType: .Men, serviceRequested: false))
        self.buttons.append(ButtonStruct(floor: "1", location: "Women", locationType: .Women, serviceRequested: false))
        self.buttons.append(ButtonStruct(floor: "2", location: "Men", locationType: .Men, serviceRequested: false))
        self.buttons.append(ButtonStruct(floor: "2", location: "Women", locationType: .Women, serviceRequested: false))
        self.buttons.append(ButtonStruct(floor: "2", location: "Family", locationType: .Family, serviceRequested: true))
        self.buttons.append(ButtonStruct(floor: "3", location: "Men", locationType: .Men, serviceRequested: false))
        self.buttons.append(ButtonStruct(floor: "3", location: "Women", locationType: .Women, serviceRequested: false))
        self.buttons.append(ButtonStruct(floor: "3", location: "Family", locationType: .Family, serviceRequested: false))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getServiceRequested(withNotification : NSNotification) {
        
        let serviceRequested = withNotification.object as! Bool
        
        print("serviceRequested = \(serviceRequested)")
        
        if(serviceRequested == true) {
            self.postRequest(serviceRequest: true)
        }
        
        self.buttons[2].serviceRequested = serviceRequested
        self.collectionView?.reloadData()
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
            
//            OperationQueue.main.addOperation({ () -> Void in
//                self.backgroundColor = UIColor.green
//            })
            
        }
        
        task.resume()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.buttons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ButtonCollectionViewCell
            
        cell.floorLabel.text = self.buttons[indexPath.row].floor
        
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        
        if (indexPath.row == 2) {
            cell.liveButton = true
        }
        
        switch self.buttons[indexPath.row].locationType {
            case .Family:
                cell.imageView.image = UIImage.init(named: "noun_637610_cc")
                break
            case .Men:
                cell.imageView.image = UIImage.init(named: "noun_637612_cc")
                break
            case .Women:
                cell.imageView.image = UIImage.init(named: "noun_637616_cc")
                break
        }
        
        if (self.buttons[indexPath.row].serviceRequested) {
            cell.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 118/255, blue: 122/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(colorLiteralRed: 73/255, green: 190/255, blue: 170/255, alpha: 1)
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
