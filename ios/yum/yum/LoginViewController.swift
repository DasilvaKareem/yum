//
//  LoginViewController.swift
//  yum
//
//  Created by Kareem Dasilva on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    private var ref: DatabaseReference!
    private var userHelper: BaseUserHelper? = nil

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var loginButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        userHelper = (UIApplication.shared.delegate as! AppDelegate).userHelper
        self.ref = Database.database().reference()

        loginButton?.layer.borderColor = UIColor.white.cgColor
        loginButton?.layer.cornerRadius = 8
        loginButton?.layer.borderWidth = 1

        emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logic(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextfield.text {
            self.signIn(email: email, password: password)
        }
    }

    func signIn(email: String, password: String) {
        userHelper?.loginWith(email: email, password: password, ref: self.ref) { (loggedIn) in
            if loggedIn {
                print("logged in successfully")
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if error == nil {
                        print("Can't sign in user")
                    } else {
                        self.dismiss(animated: true, completion: {
         
                        })
                    }
                }

            } else {
                print("there is an error with logging in")
                let alertController = UIAlertController(title: "Sorry", message: "Either your password or email is incorrect, try again.", preferredStyle: UIAlertControllerStyle.alert)

                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                {
                    (result: UIAlertAction) -> Void in
                    print("You pressed OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

