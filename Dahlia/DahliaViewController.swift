//
//  DahliaViewController.swift
//  Dahlia
//
//  Created by Echo on 9/9/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit
import Mantis
import Impression

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
            let vc = Mantis.cropViewController(image: UIImage())
        }
        
        if self.config.features.contains(.filter) {
            let vc = Impression.createFilterViewController(image: UIImage(), delegate: nil, useDefaultFilters: true)
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
