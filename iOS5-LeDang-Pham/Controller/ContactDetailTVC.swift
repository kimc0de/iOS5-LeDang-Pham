//
//  ContactDetailTVC.swift
//  iOS5-LeDang-Pham
//
//  Created by Kim on 17.12.20.
//

import UIKit

class ContactDetailTVC: UITableViewController, UITextFieldDelegate {
    
    var card = AddressCard()
    var hobbies = [String]()
    var friends = [AddressCard]()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        hobbies = card.hobbies
        friends = card.friends
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reload new friend list
        //self.friends = card.friends
        
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateInfo((Any).self)
        
    }
    
    // MARK: - Table view data source
    // MARK: - Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    // MARK: - Rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        } else if section == 1 {
            return hobbies.count
        } else if section == 2 {
            return friends.count
        } else {
            return 0
        }
    }
    
    // MARK: - Cells per row
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        if indexPath.section == 0{ //general details section
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardDetail", for: indexPath) as! GeneralDetailTVCell
            cell.infoText.delegate = self
            switch indexPath.row {
            case 0:
                cell.infoLabel.text = "First Name"
                cell.infoText.text = card.firstName
            case 1:
                cell.infoLabel.text = "Last Name"
                cell.infoText.text = card.lastName
            case 2:
                cell.infoLabel.text = "Street"
                cell.infoText.text = card.street
            case 3:
                cell.infoLabel.text = "Post Code"
                cell.infoText.text = String(card.postCode )
            case 4:
                cell.infoLabel.text = "City"
                cell.infoText.text = card.city
            default:
                break
            }
            return cell
        }
        
        else if indexPath.section == 1 { //hobbies section
            let cell = tableView.dequeueReusableCell(withIdentifier: "hobbiesDetail", for: indexPath) as! HobbiesTVCell
            cell.hobbyText?.delegate = self
            cell.hobbyText?.text = hobbies[indexPath.row]
            return cell
        }
        
        else { //friends detail section
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsDetail", for: indexPath) as! FriendsTVCell
            let friend = friends[indexPath.row]
            cell.textLabel?.text = friend.getFullName()
            cell.detailTextLabel?.text = friend.getFullAddress()
            cell.detailTextLabel?.textColor = UIColor.gray
            return cell
        }
    }
    
    // MARK: - Header for sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else if section == 1 {
            return "Hobbies"
        } else if section == 2 {
            return "Friends"
        } else {
            return ""
        }
    }
    
    // MARK: - Editing functions
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 1 && indexPath.row == (hobbies.count - 1) {
            return .insert //add one row at the end of section if insert a hobby
        } else {
            return .delete //delete the row if remove hobby
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 0 { //can only edit row general information
            return true
        }
        else {
            return false
        }
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 1 {
                self.card.hobbies.remove(at: indexPath.row)
                hobbies.remove(at: indexPath.row)
            } else if indexPath.section == 2 {
                self.card.friends.remove(at: indexPath.row)
                friends.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            if indexPath.section == 1 {
                print(indexPath.row)
                let cell = tableView.dequeueReusableCell(withIdentifier: "hobbiesDetail", for: indexPath) as! HobbiesTVCell
                if let newHobby = cell.hobbyText.text {
                    
                    // add new hobby and insert new line
                    hobbies.insert(newHobby, at: hobbies.count-1)
                    for i in 0..<hobbies.count {
                        print("\(i). \(hobbies[i])")
                    }
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                    
                    setEditing(false, animated: false)
                    setEditing(true, animated: false)
                    
                }
            }
        }    
    }
    
    
    
    // Update general details and hobbies after user edits their information
    @IBAction func updateInfo(_ sender: Any) {
        //update general details
        let cellFirstname = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! GeneralDetailTVCell
        let firstname = cellFirstname.infoText.text ?? card.firstName
        
        let cellLastname = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! GeneralDetailTVCell
        let lastname = cellLastname.infoText.text ?? card.lastName
        
        let cellStreet = tableView.cellForRow(at: IndexPath(row:2, section:0)) as! GeneralDetailTVCell
        let street = cellStreet.infoText.text ?? card.street
        
        let cellPostcode = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! GeneralDetailTVCell
        let postcode = Int(cellPostcode.infoText.text!) ?? card.postCode
        
        let cellCity = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! GeneralDetailTVCell
        let city = cellCity.infoText.text ?? card.city
        
        card.updateCard(firstName: firstname, lastName: lastname, street: street, postCode: postcode, city: city)
        
        // update hobbies
        /*
         let cellHobby = tableView.cellForRow(at: IndexPath(row: hobbies.count, section: 1)) as! HobbiesTVCell
         let hobby = cellHobby.hobbiesText.text ?? hobbies[hobbies.count-1]
         self.hobbies.append(hobby)
         */
        
        
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? ContactFriendsTVC {
            controller.friends = friends
            controller.card = card
        }
    }
    
    //MARK: Hide keyboard after enter
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
