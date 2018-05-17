//
//  StartupListTableViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import FirebaseDatabase

private struct Constants {
    static let startupCell = "Startup"
}

class StartupListTableViewController: TableViewController {

    
    var listOfStartups: [Startup] = []
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }
    
    private func getAllStartups() {
        Startup.getStartupList() { allStartups, message in
            if message == nil {
                for startup in allStartups! {
                    self.listOfStartups.append(startup)
                }
                self.tableView.reloadData()
            } else {
                self.showAlert(with: .error, message: message)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        getAllStartups()
        print(listOfStartups)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfStartups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.startupCell,
                                                 for: indexPath) as! StartupTableViewCell
        
        let startup = listOfStartups[indexPath.item]
        cell.info = startup
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView,
//                            didSelectRowAt indexPath: IndexPath) {
//        completion(self.currencies[indexPath.item])
//        navigationController?.popViewController(animated: true)
//    }
    



}