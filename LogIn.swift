//
//  LogIn.swift
//  FinalApp
//
//  Created by Duc Nguyen on 12/1/18.
//  Copyright © 2018 Duc Nguyen. All rights reserved.
//

import UIKit
import Firebase

class LogIn: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Login successful!")
                
                self.ref.child("Customers").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let customerType = value?["Type"] as? String ?? ""
                    if customerType == "Employee" {
                        self.performSegue(withIdentifier: "employeeSegue", sender: self)
                    }
                    else {
                        self.performSegue(withIdentifier: "employerSegue", sender: self)
                    }
                }
            }
        }
        
    }
    
}
