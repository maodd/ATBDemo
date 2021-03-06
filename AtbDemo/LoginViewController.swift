//
//  LoginViewController.swift
//  AtbDemo
//
//  Created by Frank Mao on 2019-01-30.
//  Copyright © 2019 mazoic. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        guard let username = usernameField.text,
        let password = passwordField.text
            else{
                return
        }
        
        spinner.startAnimating()
        self.loginButton.setTitle("", for: .normal)
        self.loginButton.isEnabled = false
        
        WebService.userLogin(username: username, password: password) { (user, error) in

         
            if let error = error {
                DispatchQueue.main.sync {
                    self.errorMessageLabel.text = error
                    self.stopSpinner()
                }
                return
            }
            
            if let user = user {
                
                Session.shared.CurrentUser = user
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC")
                
                DispatchQueue.main.sync {
                    self.errorMessageLabel.text = ""
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                
                
                
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func stopSpinner() {
        
        self.spinner.stopAnimating()
        self.loginButton.setTitle("Login", for: .normal)
        self.loginButton.isEnabled = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.stopSpinner()
    }
}
