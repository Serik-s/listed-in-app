//
//  ProfileTableViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import FirebaseAuth

private struct Constants {
    static let feedbackSegue = "feedback segue"
    static let networkStateSegue = "Network State Segue"
    static let logOut = "Logout"
    static let cancel = "Cancel"
    static let reboot = "Reboot"
    static let rebooting = "Rebooting"
    static let AuthorizationNC = ""
}


private enum ProfileActionsRowType: Int {
    case profileInfo = 0
    case settingsHeading = 1
    case sendFeedback = 2
    case favourites = 3
    case logout = 4
}

class ProfileTableViewController: TableViewController {
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userTypeAndEmailLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: AttributedImageView!
    
    let user = Auth.auth().currentUser

    private func setUser() {
        if user != nil {
            userFullNameLabel.text = user?.displayName
            userTypeAndEmailLabel.text = user?.email
            if let url = user?.photoURL {
                ImageManager.downloadImage(from: url) { image in
                    DispatchQueue.main.async {
                        self.userAvatarImageView.image = image
                    }
                }
            }
        }
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.frame.height/2
        self.userAvatarImageView.layer.masksToBounds = true
        self.navigationController?.navigationBar.isHidden = true
        setUser()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) clicked row number")
        tableView.deselectRow(at: indexPath, animated: true)
        switch ProfileActionsRowType(rawValue: indexPath.row)! {
        case .sendFeedback:
            performSegue(withIdentifier: Constants.feedbackSegue, sender: nil)
        case .logout:
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let logoutAction = UIAlertAction(title: Constants.logOut, style: .destructive) { UIAlertAction in
                User.logOut() { message in
                    if message != nil {
                        self.showAlert(with: .error, message: message!)
                    } else {
                        appStorage.loggedIn = false
                        appStorage.clear()
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = Storyboard.authorizationController
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil)
            alert.addAction(logoutAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
 
}
