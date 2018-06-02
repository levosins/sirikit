//
//  IntentHandler.swift
//  SiriKitExtension
//
//  Created by Elizabeth Levosinski on 6/30/17.
//  Copyright © 2017 DTE Energy. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
  
    let payBillRequestHandler = PayBillRequestHandler()

    override func handler(for intent: INIntent) -> Any? {
        if intent is INPayBillIntent {
            return payBillRequestHandler
        }
        
        return .none
    }
}
