//
//  EmployerSignUp.swift
//  FinalApp
//
//  Created by Duc Nguyen on 12/1/18.
//  Copyright © 2018 Duc Nguyen. All rights reserved.
//

import UIKit
import Firebase

class EmployerSignUp: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
        if error != nil {
            print(error!)
        }
        else {
            print("Sign up successful!")
            let employerID = Int.random(in: 100000 ..< 1000000)
            
            let emailDict = ["Email" : Auth.auth().currentUser?.email]
            
            self.ref.child("Employers IDs").child(String(employerID)).updateChildValues(emailDict as [AnyHashable : Any])
            
            self.ref.child("Customers").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Type" : "Employer"])
            
            self.performSegue(withIdentifier: "employerSegue", sender: self)
        }
        }
    }
    
}
