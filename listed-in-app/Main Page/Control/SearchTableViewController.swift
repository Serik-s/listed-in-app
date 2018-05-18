//
//  SearchTableViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

private struct Constants {
    static let startupCell = "searched startup"
    static let detailSegue = "startup_detail"
}


class SearchTableViewController: TableViewController, UITextFieldDelegate {
    
    var listOfStartups: [Startup] = []
    var searchedList: [Startup] = []
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
//            lastTwitterRequest = nil                // REFRESHING
//            tweets.removeAll()
//            tableView.reloadData()
//            searchForStartup()
            title = searchText
        }
    }
    
    
    private func searchForStartup() {
        for startup in listOfStartups {
            if searchText?.lowercased() == startup.name.lowercased() {
                searchedList.append(startup)
            }
        }
    }
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForStartup()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfStartups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.startupCell,
                                                 for: indexPath) as! SearchedStartupTableViewCell
        
        let startup = listOfStartups[indexPath.item]
        cell.info = startup
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView,
//                            didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: Constants.detailSegue, sender: tableView)
//
//    }
    
    
    

}
