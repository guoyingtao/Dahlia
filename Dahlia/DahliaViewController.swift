//
//  DahliaViewController.swift
//  Dahlia
//
//  Created by Echo on 9/9/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit
import Mantis

class DahliaViewController: UIViewController {
    
    public var image: UIImage?
    public var config = Dahlia.Config()
    
    init(image: UIImage, config: Dahlia.Config) {
        self.image = image
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.config.features.contains(.crop) {
            let cropViewController = Mantis.cropViewController(image: UIImage())
        }
        
        if self.config.features.contains(.filter) {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
