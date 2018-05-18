//
//  SendFeedbackTableViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import FirebaseAuth
import ObjectMapper

class SendFeedbackTableViewController: TableViewController {

    
    @IBOutlet weak var feedbackTextField: UITextField!{
        didSet {
            feedbackTextField.tintColor = Colors.blueColor
        }
    }
    @IBOutlet var stars: [UIButton]!
    
    var user = Auth.auth().currentUser!
    fileprivate var isSelected = false
    fileprivate var previousSelected = -1
    fileprivate var feedback = Feedback(JSON: [:])!
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    

    private func paintStars(_ index: Int, goingToSelect: Bool) {
        
        if goingToSelect == true || index != previousSelected {
            previousSelected = index
            for star in stars {
                if star.tag <= index {
                    star.setImage(#imageLiteral(resourceName: "selected_star"), for: .normal)
                } else {
                    star.setImage(#imageLiteral(resourceName: "unselected_star"), for: .normal)
                }
            }
        } else {
            for star in stars {
                star.setImage(#imageLiteral(resourceName: "unselected_star"), for: .normal)
            }
        }
    }
    
    
    @IBAction func selectStar(_ sender: UIButton) {
        print(sender.tag)
        if !isSelected {
            feedback.rating = sender.tag
        }
        isSelected = !isSelected
        paintStars(sender.tag, goingToSelect: isSelected)
        
        feedback.rating = sender.tag
    }
    
    
    @IBAction func sendFeedback() {
        if isSelected == true && !(feedbackTextField.text?.isEmpty)! {
            feedback.text = feedbackTextField.text!
            feedback.username = user.displayName ?? " "
            
            let date = Date()
            Feedback.setFeedback(date, feedback: feedback, userID: user.uid)
            
            let alert = UIAlertController(title: Title.feedbackSent.rawValue,
                                          message: Message.feedbackHasBeenSent.description,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Title.close.rawValue,
                                          style: .cancel,
                                          handler: { _ in
                                            self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        } else  {
            self.showAlert(with: .error, message: .enterFeedback)
        }
    }
    
    
    
}
