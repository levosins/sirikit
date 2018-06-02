//
//  APIManager.swift
//  SiriKitExtension
//
//  Created by Elizabeth Levosinski on 4/13/18.
//  Copyright © 2018 Elizabeth Levosinski. All rights reserved.
//

import Foundation
import Intents

class APIManager {
    
    static func getCustomerData(complete: (Error?, Customer?) -> Void) {
        // This is where your api call for a customer would return all the info you needed
        // These are just custom structs to fake the data being populated
        
        let balance1 = Balance(totalAmountDue: 100.0, dueDate: "2014-10-05T08:15:30-05:00")
        let address1 = Address(street: "123 Fake St", zipCode: "12345")
        let charges1 = Charge(type: "gas", amount: 35.89)
        let summaryOfCharges1 = Charges(startDate: "2014-10-05T08:15:30-05:00",
                                        endDate: "2014-11-05T08:15:30-05:00",
                                        billId: "123123123123",
                                        billTotal: 198.73,
                                        billDueDate: "2014-12-05T08:15:30Z",
                                        billingDays: 31,
                                        totalPayments: 1.0,
                                        totalAmountDue: 25.12,
                                        pastDue: 35.89,
                                        charges: [charges1])
        
        let balance2 = Balance(totalAmountDue: 250.0, dueDate: "2014-10-05T08:15:30-05:00")
        let address2 = Address(street: "456 Fake St", zipCode: "67890")
        let charges2 = Charge(type: "gas", amount: 35.89)
        let summaryOfCharges2 = Charges(startDate: "2014-10-05T08:15:30-05:00",
                                        endDate: "2014-11-05T08:15:30-05:00",
                                        billId: "444423123123",
                                        billTotal: 144.73,
                                        billDueDate: "2014-12-05T08:15:30Z",
                                        billingDays: 31,
                                        totalPayments: 0.0,
                                        totalAmountDue: 67.12,
                                        pastDue: 88.89,
                                        charges: [charges2])
        
        let accounts = [
            Account(name: "Checking Account",
                    number: "4141414141414141",
                    balance: balance1,
                    address: address1,
                    summaryOfCharges: summaryOfCharges1),
            Account(name: "Visa",
                    number: "4242424242424242",
                    balance: balance2,
                    address: address2,
                    summaryOfCharges: summaryOfCharges2)
        ]
        
        let customer = Customer(name: "Sally", accounts: accounts)
        
        complete(nil, customer)
    }
    
    static func getUserAccountData(for customer: Customer, complete: (Error?, [Account]) -> Void) {
        complete(nil, customer.accounts)
    }
    
    static func getSavedPaymentMethod(complete: (Error?, SavedPaymentMethod?) -> Void) {
        // This is where you would make an api call to return the user's saved payment method
        let savedPaymentMethod = SavedPaymentMethod(nameOnPaymentAccount: "John Smith",
                                                    id: "123124238",
                                                    nickName: "Chase Account",
                                                    type: "cheque",
                                                    kind: "Checking",
                                                    nameOfBankOrCard: "Bank of America",
                                                    routingNumber: "1234567",
                                                    bankAccountNumber: "8734",
                                                    creditCardNumber: "7777",
                                                    expirationMonth: "01",
                                                    expirationYear: "2012")
        
        complete(nil, savedPaymentMethod)
    }
    
   static func submitPayment(savedPaymentMethod: SavedPaymentMethod, successfulResponse: INPayBillIntentResponse, complete: @escaping (INPayBillIntentResponse) -> Void) {
        // Here's an example of an api request you could do:
        // let failedResponse = INPayBillIntentResponse(code: .failure, userActivity: .none)
        //    var url: String = "http://sampleapirequest.com"
        //
        //    guard let devPostPath = URL(string: url) else {
        //      completion(failedResponse)
        //      return
        //    }
        //
        //    var request = URLRequest(url: devPostPath)
        //    request.httpMethod = "POST"
        //
        //    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        //      guard let _ = data, error == nil else {
        //        print("error=\(String(describing: error))")
        //        completion(failedResponse)
        //        return
        //      }
        //
        //      if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200  {
        //        completion(failedResponse)
        //      } else {
        //        completion(successfulResponse) // Return the result back to SiriKit.
        //      }
        //    }
        //
        //    task.resume()
    
        complete(successfulResponse)
    }
    
}
