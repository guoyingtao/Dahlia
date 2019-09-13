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

protocol DahliaProtocol {
    func didCancel()
    func didProcessedImage(image: UIImage?)
}

class DahliaViewController: UIViewController {
    
    public var image: UIImage?
    public var config = Dahlia.Config()
    public var delegate: DahliaProtocol?
    
    init?(image: UIImage, config: Dahlia.Config) {
        
        guard let cgImage = image.cgImage?.copy() else {
            return nil
        }
        
        self.image = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Magic", style: .plain, target: nil, action: nil)
        
        if self.config.features.contains(.crop) {
            let vc = Mantis.cropViewController(image: UIImage())
            
        }
        
        if self.config.features.contains(.filter) {
            let vc = Impression.createFilterViewController(image: UIImage(), delegate: nil, useDefaultFilters: true)
        }
    }
    

    func confirmCancel() {
        
    }
    
    func cancel() {
        
    }
    
    func confirm() {
        delegate?.didProcessedImage(image: image)
    }
}
