//
//  ContactListViewController.swift
//  iOS5-LeDang-Pham
//
//  Created by Tùng Linh Phạm Bá on 16.12.20.
//

import UIKit

class ContactListTVC: UITableViewController {
    
    
    var myAddressBook = AddressBook()
    var sectionTitles = [String]()
    var sectionRows = [[AddressCard]]()
    var selectedAddressCard = AddressCard()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Passing variable from AppDelegate
        if let del = UIApplication.shared.delegate as? AppDelegate {
            // access properties
            myAddressBook = del.myAddressBook
        }
       updateAddressCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateAddressCard()
        tableView.reloadData()
    }
    
    func updateAddressCard(){
        sectionTitles = myAddressBook.getAlphabetListFromLastName()
        sectionRows = myAddressBook.getAddressBookInStringArray()
    }

    // MARK: - Table view data source
    // MARK: - Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }
    // MARK: - Rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionRows[section].count
    }

    // MARK: - Cells per row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = sectionRows[indexPath.section][indexPath.row].getFullName()
        cell.detailTextLabel?.text = sectionRows[indexPath.section][indexPath.row].getFullAddress()
        cell.detailTextLabel?.textColor = UIColor.gray
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            sectionRows[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            myAddressBook.remove(card: sectionRows[indexPath.section][indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAddressCard = sectionRows[indexPath.section][indexPath.row]
    }
  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newContact" {
            if let controller = segue.destination as? ContactNewTVC {
                controller.myAddressBook = self.myAddressBook
            }
        }
        if segue.identifier == "contactDetails" {
            if let controller = segue.destination as? ContactDetailTVC {
                if let indexPath = tableView.indexPathsForSelectedRows?.first {
                    controller.card = sectionRows[indexPath.section][indexPath.row]
                }
            }
        }
    }
}
