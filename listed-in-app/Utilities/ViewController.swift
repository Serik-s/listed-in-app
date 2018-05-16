//
//  ViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController,  NVActivityIndicatorViewable {

    // отображает ошибку на экране
    func showAlert(with title: Title?, message: Message?) {
        let alertVC = UIAlertController(title: title?.rawValue,
                                        message: message?.description,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: Title.close.rawValue,
                                        style: .default,
                                        handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - жизненный цикл
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // снимает фокус со всех view
        view.endEditing(true)
        
        // Назначает для кнопки назад текст
        // так как он генеруется от названия предыдущей view'шки
        navigationItem.backBarButtonItem = UIBarButtonItem(title: Title.back.rawValue, style: .plain, target: nil, action: nil)
    }

}
