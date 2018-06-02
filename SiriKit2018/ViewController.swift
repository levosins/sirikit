//
//  ViewController.swift
//  SiriKit2018
//
//  Created by Elizabeth Levosinski on 4/13/18.
//  Copyright © 2018 Elizabeth Levosinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = Helpers.userIsLoggedIn() ? CustomMessages.loggedIn : CustomMessages.loggedOut
    }
    
    private func userSignIn(complete: (Error?) -> Void) {
        // Add custom sign in logic
        complete(nil)
    }
    
    private func userSignOut(complete: (Error?) -> Void) {
        // Add custom sign out logic
        complete(nil)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        userSignIn { error in
            statusLabel.text = CustomMessages.loggedIn
            
            // Update user defaults so we know user is signed in
            Helpers.updateSharedData(status: true)
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        userSignOut { error in
            statusLabel.text = CustomMessages.loggedOut
            
            // Update user defaults so we know user is signed out
            Helpers.updateSharedData(status: false)
        }
    }

}
