//
//  SignInViewController.swift
//  ABA
//
//  Created by Edward Suczewski on 12/15/15.
//  Copyright © 2015 Edward Suczewski. All rights reserved.
//

import Foundation

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: UI Outlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Alerts
    func alertForOutcome(outcome: Int) {
        var title: String
        var message: String
        switch outcome {
        case 1987:
            title = "Account Created!"
            message = "Please sign in using the password you provided."
        case 2015:
            title = "Password Reset!"
            message = "A temporary password was sent to \(emailAddressTextField.text!). It will be active for 24 hours."
        case -5:
            title = "E-mail Not Valid"
            message = "\(emailAddressTextField.text!) is not a valid e-mail address. Please check your e-mail address and try again."
        case -6:
            title = "Password Not Valid"
            message = "Please re-enter your password and try again."
        case -8:
            title = "E-mail Not Recognized"
            message = "\(emailAddressTextField.text!) is not associated with an existing account. Please create a new account."
        case -9:
            title = "E-mail Already In Use"
            message = "An account already exists for \(emailAddressTextField.text!). Please sign in."
        default:
            title = "Unknown Error"
            message = "Please check your internet connection and try again."
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func resetPasswordAlert() {
        let alert = UIAlertController(title: "Reset password?", message: "Are you sure you want to reset your password? An e-mail containing a temporary password will be sent to \(emailAddressTextField.text!).", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Reset Password", style: .Destructive, handler: { (_) -> Void in
            FirebaseController.base.resetPasswordForUser(self.emailAddressTextField.text) { (error) -> Void in
                if let error = error {
                    self.alertForOutcome(error.code)
                } else {
                    self.alertForOutcome(2015)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: UI Actions
    
    @IBAction func signInButtonTapped(sender: UIButton) {
        if let email = emailAddressTextField.text {
            if let password = passwordTextField.text {
                UserController.authenticateUser(email, password: password, completion: { (user, error) -> Void in
                    if let error = error {
                        self.alertForOutcome(error.code)
                    } else if let user = user {
                        UserController.sharedController.currentUser = user
                        self.performSegueWithIdentifier("signIn", sender: nil)
                    }
                    self.passwordTextField.text = ""
                })
            }
        }
    }
    
    @IBAction func createNewAccountButtonTapped(sender: UIButton) {
        if let email = emailAddressTextField.text {
            if let password = passwordTextField.text {
                FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
                    if error == nil {
                        if let uid = response["uid"] as? String {
                            var user = User(email: email, uid: uid)
                            user.save()
                            self.alertForOutcome(1987)
                        }
                    } else {
                        self.alertForOutcome(error.code)
                        print(error.code)
                    }
                    self.passwordTextField.text = ""
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(sender: UIButton) {
        self.resetPasswordAlert()
        self.passwordTextField.text = ""
    }
    
}
