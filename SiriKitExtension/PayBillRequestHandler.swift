//
//  PayBillRequestHandler.swift
//  SiriKitSwift
//
//  Created by Elizabeth Levosinski on 6/21/17.
//  Copyright © 2017 Elizabeth Levosinski. All rights reserved.
//

import Foundation
import Intents

class PayBillRequestHandler: NSObject {
    var transactionAmount: INPaymentAmount?
    var transactionScheduledDate: INDateComponentsRange?
    var billDetails: INBillDetails?
    var fromAccount: INPaymentAccount?
    let userDefaults = UserDefaults.init(suiteName: suiteName)
    var savedPaymentMethod: SavedPaymentMethod?
    var accounts: [Account]?
    var billPayeesArray = [INBillPayee]()
    var customerData: Customer?

    // MARK: Populate SiriKit Intent
    
    func createPayBillIntentResponse(codeType: INPayBillIntentResponseCode, completion: @escaping (INPayBillIntentResponse, SavedPaymentMethod?) -> Void) {
        let failedResponse = INPayBillIntentResponse(code: .failure, userActivity: nil)

        createFromAccount { (wasSuccessful) in
            guard wasSuccessful else {
                completion(failedResponse, nil)
                return
            }

            let response = self.createResponse(with: codeType)
            completion(response, self.savedPaymentMethod) // Return the result back to SiriKit.
        }
    }
    
    // MARK: Create INPayBillIntentResponse object

    func createResponse(with code: INPayBillIntentResponseCode) -> INPayBillIntentResponse {
        let response = INPayBillIntentResponse(code: code, userActivity: nil)
        response.transactionAmount = self.transactionAmount
        response.transactionScheduledDate = self.transactionScheduledDate
        response.billDetails = self.billDetails
        response.fromAccount = self.fromAccount
        response.transactionNote = CustomMessages.transactionNote
        return response
    }

    // MARK: Populate the fromAccount property for the INPayBillIntentResponse
    
    func createFromAccount(complete: @escaping (Bool) -> Void) { // User Payment/Bank Info
        guard self.fromAccount == nil else {
            complete(true)
            return
        }

        APIManager.getSavedPaymentMethod { error, paymentMethod in
            guard let savedPaymentMethod = paymentMethod else {
                complete(false)
                return
            }

            self.savedPaymentMethod = savedPaymentMethod
            let userPaymentNickName = INSpeakableString(spokenPhrase: savedPaymentMethod.nickName)
            let userBankOrCardNumber = savedPaymentMethod.creditCardNumber != nil ? savedPaymentMethod.creditCardNumber : savedPaymentMethod.bankAccountNumber
            let userCardOrBankName = INSpeakableString(spokenPhrase: savedPaymentMethod.nameOfBankOrCard)
            
            // An INPaymentAccount is a user account that provides the funds when making a payment.
            self.fromAccount = INPaymentAccount(nickname: userPaymentNickName,
                                                number: userBankOrCardNumber,
                                                accountType: .checking,
                                                organizationName: userCardOrBankName,
                                                balance: nil, // could be miles, money, points, or unknown
                                                secondaryBalance: nil) // A secondary balance associated with the account. For example, a credit card account might have points or frequent flier miles based on the user's purchases.
            
            complete(true)
        }
    }
    
    // MARK: Populate the billDetails property for the INPayBillIntentResponse
    
    func finishBillDetails(account: Account, billPayee: INBillPayee) {
        let charges = account.summaryOfCharges
        let billTotal = charges.billTotal
        
        guard let chargesDueDate = charges.billDueDate.convertStringToDate(),
            let chargesStart = charges.startDate.convertStringToDate(),
            let chargesEnd = charges.endDate.convertStringToDate() else { return }
        
        let dueDate: DateComponents = chargesDueDate.convertDate()
        let paymentDate = Date().convertDate()
        
        // Converting the account data to the correct currency for the INBillDetails object
        let lateFee = INCurrencyAmount(amount: 0, currencyCode: "USD")
        let amountDue = INCurrencyAmount(amount: NSDecimalNumber(value: billTotal), currencyCode: "USD")
        let minDue = INCurrencyAmount(amount: NSDecimalNumber(value: billTotal), currencyCode: "USD")
        
        // This is setting the actual amount the user is going to pay off, currently this example just
        // automatically has the user paying the bill all off at once
        self.transactionAmount = INPaymentAmount(amountType: .amountDue, amount: amountDue)

        self.billDetails = INBillDetails(billType: .electricity,
                                         paymentStatus: .unpaid,
                                         billPayee: billPayee,
                                         amountDue: amountDue,
                                         minimumDue: minDue,
                                         lateFee: lateFee,
                                         dueDate: dueDate,
                                         paymentDate: paymentDate)

        self.transactionScheduledDate = Helpers.getDateRange(startDate: chargesStart, endDate: chargesEnd)
    }

    // MARK: Creates the BillPayee for the INPayBillIntentResponse. The user selects the BillPayee if there are multiple accounts

    func createBillPayee(paymentAccounts: [Account]) -> INBillPayeeResolutionResult? {
        var result: INBillPayeeResolutionResult?
        var companyAcountNum: String?
        let companyName = INSpeakableString(spokenPhrase: "The Electric Company")
        
        if paymentAccounts.count > 1 {
            for account in paymentAccounts {
                companyAcountNum = account.number
                
                // The account nicknames are dynamically populated with a mailing address
                // to make it easy to differentiate between each account
                let companyAccountNickname = INSpeakableString(spokenPhrase: account.address.street + " " + account.address.zipCode)

                if let billPayee = INBillPayee(nickname: companyAccountNickname, number: companyAcountNum, organizationName: companyName) {
                    self.billPayeesArray.append(billPayee)
                }
            }

            result = INBillPayeeResolutionResult.disambiguation(with: self.billPayeesArray)
        } else {
            let companyAccountNickname = INSpeakableString(spokenPhrase: "The Electric Company Payment Account")
            companyAcountNum = paymentAccounts[0].number

            if let billPayee = INBillPayee(nickname: companyAccountNickname, number: companyAcountNum, organizationName: companyName) {
                result = INBillPayeeResolutionResult.success(with: billPayee)
            }
        }

        return result
    }

}

extension PayBillRequestHandler: INPayBillIntentHandling {
    
    // MARK: Resolution Phase
    
    func resolveBillPayee(for intent: INPayBillIntent, with completion: @escaping (INBillPayeeResolutionResult) -> Void) {
        APIManager.getCustomerData { error, customer in
            self.customerData = customer
            
            if !Helpers.userIsLoggedIn() { // if the user is not logged in it will fail
                guard let emptyPayee = INBillPayee(nickname: INSpeakableString(spokenPhrase: ""), number: nil, organizationName: nil) else { return }
                let result = INBillPayeeResolutionResult.success(with: emptyPayee)
                completion(result)
                return
            }
            
            if billPayeesArray.count > 0 {
                guard let selectedPayee = intent.billPayee else { return }
                let result = INBillPayeeResolutionResult.success(with: selectedPayee)
                completion(result)
            } else {
                guard let customer = customer else { return }
                APIManager.getUserAccountData(for: customer) { error, userAccounts  in
                    self.accounts = userAccounts
                    
                    guard let paymentAccounts = self.accounts else { return }
                    guard let finalResult = self.createBillPayee(paymentAccounts: paymentAccounts) else { return }
                    
                    completion(finalResult) // send data back to SiriKit
                }
            }
        }
    }
    
    // MARK: Confirmation Phase
    
    func confirm(intent: INPayBillIntent, completion: @escaping (INPayBillIntentResponse) -> Void) {
        if !Helpers.userIsLoggedIn() {
            let failedResponseLoggedOut = INPayBillIntentResponse(code: .failureCredentialsUnverified, userActivity: nil)
            completion(failedResponseLoggedOut)
            return
        }
        
        guard let currentBillPayee = intent.billPayee else {
            let response = INPayBillIntentResponse(code: .failure, userActivity: nil)
            completion(response)
            return
        }
        
        guard let accounts = self.accounts else {
            let response = INPayBillIntentResponse(code: .failure, userActivity: nil)
            completion(response)
            return
        }
        
        for account in accounts {
            if account.number == currentBillPayee.accountNumber {
                finishBillDetails(account: account, billPayee: currentBillPayee)
            }
        }
        
        createPayBillIntentResponse(codeType: .ready) { (response, _) in
            completion(response)
        }
    }
    
    // MARK: Handling the Intent Phase
    
    func handle(intent: INPayBillIntent, completion: @escaping (INPayBillIntentResponse) -> Void) {
        createPayBillIntentResponse(codeType: .success) { (response, savedPaymentMethod) in
            guard let savedPaymentMethod = self.savedPaymentMethod else {
                completion(response)
                return
            }
            
            APIManager.submitPayment(savedPaymentMethod: savedPaymentMethod, successfulResponse: response, complete: completion)
        }
    }
    
}
