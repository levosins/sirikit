//
//  Models.swift
//  SiriKitExtension
//
//  Created by Elizabeth Levosinski on 4/29/18.
//  Copyright © 2018 Elizabeth Levosinski. All rights reserved.
//

import Foundation

struct Account {
    let name: String
    let number: String
    let balance: Balance
    let address: Address
    let summaryOfCharges: Charges
}

struct Location {
    let latitude: Float
    let longitude: Float
}

struct Site {
    let siteId: String
    let address: String
    let postalCode: String
    let location: Location
}

struct Customer {
    let name: String
    let accounts: [Account]
}

struct SavedPaymentMethod {
    let nameOnPaymentAccount: String
    let id: String
    let nickName: String
    let type: String
    let kind: String
    let nameOfBankOrCard: String
    let routingNumber: String
    let bankAccountNumber: String?
    let creditCardNumber: String?
    let expirationMonth: String
    let expirationYear: String
}

struct Balance {
    let totalAmountDue: Float
    let dueDate: String?
}

struct Address {
    let street: String
    let zipCode: String
}

struct Charge {
    let type: String
    let amount: Float
}

struct Charges {
    let startDate: String
    let endDate: String
    let billId: String
    let billTotal: Float
    let billDueDate: String
    let billingDays: Int
    let totalPayments: Float
    let totalAmountDue: Float
    let pastDue: Float
    let charges: [Charge]
}
