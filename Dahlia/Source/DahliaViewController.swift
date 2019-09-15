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

protocol DahliaViewControllerDelegate {
    func dahliaViewControllerDidProcess(_ dahliaViewController: DahliaViewController, processedImage: UIImage)
    func dahliaViewControllerDidFailedToProcess(_ dahliaViewController: DahliaViewController, originalImage: UIImage)
    func dahliaViewControllerDidCancel(_ dahliaViewController: DahliaViewController, originalImage: UIImage)
}

extension DahliaViewControllerDelegate {
    func dahliaViewControllerDidFailedToProcess(_ dahliaViewController: DahliaViewController, originalImage: UIImage) {
        
    }
    
    func dahliaViewControllerDidCancel(_ dahliaViewController: DahliaViewController, originalImage: UIImage) {
        
    }
}

class DahliaViewController: UIViewController {
    
    public var image: UIImage?
    public var currentImage: UIImage?
    public var config = Dahlia.Config()
    public var delegate: DahliaViewControllerDelegate?
    public var imageProcessorList: [ImageProcessor] = []
    
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
            let processor = ImageProcessor(title: "Crop", icon: UIImage(), selectedIcon: UIImage(), relatedViewController: vc)
                
            imageProcessorList.append(processor)
        }
        
        if self.config.features.contains(.filter) {
            let vc = Impression.createFilterViewController(image: UIImage(), delegate: nil, useDefaultFilters: true)
            
            let processor = ImageProcessor(title: "Filter", icon: UIImage(), selectedIcon: UIImage(), relatedViewController: vc)
                
            imageProcessorList.append(processor)
        }
    }
    
    func takeoverProcessedImage(_ image: UIImage) {
        currentImage = image
    }

    func confirmCancel() {
        guard let image = image else {
            return
        }
        delegate?.dahliaViewControllerDidFailedToProcess(self, originalImage: image)
    }
    
    func cancel() {
        
    }
    
    func confirm() {
        guard let image = currentImage else {
            return
        }
        delegate?.dahliaViewControllerDidProcess(self, processedImage: image)
    }
}

extension DahliaViewController: Mantis.CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage) {
        takeoverProcessedImage(cropped)
    }
}

