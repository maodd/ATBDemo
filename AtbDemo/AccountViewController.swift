//
//  AccountViewController.swift
//  AtbDemo
//
//  Created by Frank Mao on 2019-01-30.
//  Copyright © 2019 mazoic. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.balanceLabel.text = "\(Session.shared.CurrentUser?.balance ?? 0.00)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
