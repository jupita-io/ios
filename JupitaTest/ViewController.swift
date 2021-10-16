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
        
        let jupita = Jupita("ACCESS_TOKEN", "1")
        jupita.dump(text: "Hello", inputID: "3", type:  jupita.TOUCHPOINT) { (result) -> Void in
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

