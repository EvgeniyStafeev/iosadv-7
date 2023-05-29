//
//  PostViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.11.2022.
//  
//

import Foundation
import UIKit

class PostViewController : UIViewController {
    
    var titlePost: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        self.title = titlePost
        
        let modal = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showModal))
        navigationItem.rightBarButtonItems = [modal]
    }
    
    @objc func showModal() {
        let popupViewController = InfoViewController()
        popupViewController.modalPresentationStyle = .fullScreen
        self.present(popupViewController, animated: true, completion: nil)
    }
}
