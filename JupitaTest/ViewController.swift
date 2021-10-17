//
//  ViewController.swift
//  JupitaTest
//
//  Created by Gagan on 22/05/21.
//

import UIKit
import Jupita

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = "your-authentication-token"
        let jupita = Jupita(token, "2")
        jupita.dump(text: "Hi, how are you?", inputID: "3", type:  jupita.TOUCHPOINT, isCall: false) { (result) -> Void in
            switch result {
            case .success(let json):
                debugPrint(json)
                break
            case .failure(let error):
                debugPrint(error)
                break
            }
        }
        
    }
    
}

