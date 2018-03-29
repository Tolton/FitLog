//
//  Food.swift
//  FitLog
//
//  Created by Jack on 2018-03-27.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation



class Food {
    
    var name = ""
    //var photo: UIImage?
    var calories = 0
    
    init(_ food:String, _ cals:Int) {
        self.name = food
        self.calories = cals
    }
}
