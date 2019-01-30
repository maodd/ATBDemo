//
//  AccountViewController.swift
//  AtbDemo
//
//  Created by Frank Mao on 2019-01-30.
//  Copyright © 2019 mazoic. All rights reserved.
//

import UIKit

enum AccountType : Int {
    case bankAccounts
    case lendingProducts
}

class AccountViewController: UITableViewController {

    
    
    var accounts: [UserAccount] = []
    
    var bankAccounts : [UserAccount] { get {
        return accounts.filter{$0.account.type == AccountType.bankAccounts.rawValue}
        }}
    
    var lendingProducts : [UserAccount] { get {
        return accounts.filter{$0.account.type == AccountType.lendingProducts.rawValue}
        }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        guard let currentUser = Session.shared.CurrentUser else {
            return
        }
        
        WebService.fetchUserAccounts(userObjectId: currentUser.objectId) { (userAccounts, errorMessage) in
            
            if let userAccounts = userAccounts {
                self.accounts = userAccounts
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Bank Accounts", "Lending Products"][section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return [self.bankAccounts , self.lendingProducts][section].count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)

        // Configure the cell...
        let accountList:[UserAccount] = [self.bankAccounts , self.lendingProducts][indexPath.section]
        let accountLabel = cell.viewWithTag(1) as! UILabel
        let balanceLabel = cell.viewWithTag(2) as! UILabel
        
        if indexPath.row ==  accountList.count {
            accountLabel.text = "Totals"
            let total = accountList.reduce(0){$0 + $1.balance}
            balanceLabel.text = total.moneyFormattedString()
            cell.backgroundColor = UIColor(red: 242/255.0, green: 250/255.0, blue: 255/255.0, alpha: 1.0)

        }else{
            let account = accountList[indexPath.row]
            accountLabel.text = account.account.name
            balanceLabel.text = account.balance.moneyFormattedString()
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension Float {
    func moneyFormattedString() -> String {
        let format = NumberFormatter()
        
        format.numberStyle = .currency
        
        let string = format.string(from: NSNumber(value: self))
        
        return string ?? ""
    }
}
