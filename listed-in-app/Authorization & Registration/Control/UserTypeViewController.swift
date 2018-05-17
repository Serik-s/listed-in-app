//
//  UserTypeViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

private struct Constants {
    static let investorSegue = "investor"
    static let startupSegue = "startup"
}

class UserTypeViewController: ViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    var isInvestor : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "authorization_background")!)
        // Do any additional setup after loading the view.
    }

//    @IBAction func clickedInvestor(_ sender: UIButton) {
//        isInvestor = true
//
//        performSegue(withIdentifier: Constants.investorSegue, sender: sender)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        
        case Constants.investorSegue:
            let investorDestination = segue.destination as! RegistrationViewController
//            let investorButton = sender as! UIButton
            
            investorDestination.isInvestor = true
        case Constants.startupSegue:
            let startupDestination = segue.destination as! RegistrationViewController
//            let startupButton = sender as! UIButton
            
            startupDestination.isInvestor = false
        default: break
        }
    }
    
//    @IBAction func clickedStartup(_ sender: UIButton) {
//        isInvestor = false
//        performSegue(withIdentifier: Constants.startupSegue, sender: sender)
//    }
    
    
    @IBAction func clickedInvestor(_ sender: UIButton) {
        isInvestor = true
        performSegue(withIdentifier: Constants.investorSegue, sender: sender)

    }
    
    
    @IBAction func clickedStartup(_ sender: UIButton) {
        isInvestor = false
        performSegue(withIdentifier: Constants.startupSegue, sender: sender)
    }
    

}
