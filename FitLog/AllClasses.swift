//
//  AllClasses.swift
//  FitLog
//
//  Created by Jack on 2018-03-30.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation


class Weight {
    var amount = 0.0
    var date = ""
    
    init(_ weight:Double) {
        self.amount = weight
        let date = Date()
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/yyyy"
        self.date = formatDate.string(from: date)
    }
    func toJson() -> Any {
        return [
            "amount": amount,
            "date": date]
    }
}

