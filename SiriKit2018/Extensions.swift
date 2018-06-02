//
//  Extensions.swift
//  SiriKit2018
//
//  Created by Elizabeth Levosinski on 4/29/18.
//  Copyright © 2018 Elizabeth Levosinski. All rights reserved.
//

import Foundation
import Intents

extension String {

    func convertStringToDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else { return nil }
        return date
    }

}

extension Date {
    
    func convertDate() -> DateComponents {
        let calendar = Calendar.current
        var dateComp = DateComponents()
        dateComp.year = calendar.component(.year, from: self)
        dateComp.month = calendar.component(.month, from: self)
        dateComp.day = calendar.component(.day, from: self)
        return dateComp
    }
    
}
