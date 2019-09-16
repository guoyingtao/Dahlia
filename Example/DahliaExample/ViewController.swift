//
//  ViewController.swift
//  DahliaExample
//
//  Created by Echo on 9/9/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit
import Dahlia

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func showEditor(_ sender: Any) {
        guard let image = UIImage(named: "sunflower") else { return }
        guard let vc = Dahlia.createDahliaViewController(image: image) else { return }
        present(vc, animated: true)
    }
}

