//
//  Helpers.swift
//  SiriKit2018
//
//  Created by Elizabeth Levosinski on 4/20/18.
//  Copyright © 2018 Elizabeth Levosinski. All rights reserved.
//

import Foundation
import Intents

struct Helpers {
    // Check user defaults to see if user is logged in or not
    public static func userIsLoggedIn() -> Bool {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return false }
        return defaults.bool(forKey: key)
    }

    // Set UserDefaults isSignedIn key to signify the user is signed in
    public static func updateSharedData(status: Bool) {
        if let defaults = UserDefaults(suiteName: suiteName) {
            defaults.set(status, forKey: key)
            defaults.synchronize()
        }
    }

    // MARK: Get Date Range for Due Date might need to adjust?
    public static func getDateRange(startDate: Date, endDate: Date) -> INDateComponentsRange {
        return INDateComponentsRange(start: startDate.convertDate(), end: endDate.convertDate())
    }
}
