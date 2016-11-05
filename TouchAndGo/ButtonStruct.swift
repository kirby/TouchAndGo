//
//  ButtonStruct.swift
//  TouchAndGo
//
//  Created by Kirby Shabaga on 11/5/16.
//  Copyright © 2016 Kirby Shabaga. All rights reserved.
//

import Foundation

enum LocationType {
    case Men
    case Women
    case Family
}

struct ButtonStruct {
    
    var floor: String
    var location : String
    var locationType: LocationType
    var serviceRequested : Bool
    
}
