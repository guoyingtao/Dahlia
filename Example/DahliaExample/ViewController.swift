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

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showEditor(_ sender: Any) {
        guard let image = UIImage(named: "sunflower") else { return }
        guard let vc = Dahlia.createDahliaViewController(image: image, config: Dahlia.Config(), delegate: self) else { return }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension ViewController: DahliaViewControllerDelegate {
    func dahliaViewControllerDidProcess(_ dahliaViewController: DahliaViewController, processedImage: UIImage) {
        imageView.image = processedImage
        dismiss(animated: true)
    }
}

