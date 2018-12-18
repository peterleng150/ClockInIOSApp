//
//  EmployeeSignUp.swift
//  FinalApp
//
//  Created by Duc Nguyen on 12/1/18.
//  Copyright © 2018 Duc Nguyen. All rights reserved.
//

import UIKit
import Firebase

class EmployeeSignUp: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var employerIdTextField: UITextField!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
        var employerID = employerIdTextField.text!
        employerID = String(employerID)
        
        if employerID.count == 0{
            print("You must enter an employee ID")
        }
        else {
            self.ref.child("Employers IDs").observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild(employerID) {
                    print("Employer exists!")
                    Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            print("Sign up successful!")
                            let emailDict = ["Email" : Auth.auth().currentUser?.email]
                            
                            self.ref.child("Employees").child(employerID).child((Auth.auth().currentUser?.uid)!).updateChildValues(emailDict as [AnyHashable : Any])
                            
                            self.ref.child("Customers").child((Auth.auth().currentUser?.uid)!).updateChildValues(["Type" : "Employee"])
                            
                            self.performSegue(withIdentifier: "employeeSegue", sender: self)
                        }
                    }
                }
            }
        }
    }
    

}
