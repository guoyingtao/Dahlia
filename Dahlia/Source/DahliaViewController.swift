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
    
    public var originalImage: UIImage?
    public var processedWholeImage: UIImage?
    public var processedCroppedImage: UIImage?
    public var config = Dahlia.Config()
    public var delegate: DahliaViewControllerDelegate?
    
    private var processed = false
    private var operationBar: OperationBar!
    private var stageView: UIView!
    private var currentProcessorViewController: UIViewController?
    private var previewView: PreviewView!
    
    init?(image: UIImage, config: Dahlia.Config) {
        self.originalImage = image
        self.config = config
        
        guard let image = originalImage, let cgImage = image.cgImage?.copy() else {
            return nil
        }
        
        processedWholeImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        processedCroppedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Magic", style: .plain, target: nil, action: nil)
        
        stageView = UIView()
        stageView.backgroundColor = .black
        operationBar = OperationBar()
        operationBar.backgroundColor = .red
        view.addSubview(stageView)
        view.addSubview(operationBar)
                
        stageView.translatesAutoresizingMaskIntoConstraints = false
        operationBar.translatesAutoresizingMaskIntoConstraints = false
        
        operationBar.createToolbarUI()
        
        NSLayoutConstraint.activate([
            stageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stageView.bottomAnchor.constraint(equalTo: operationBar.topAnchor),
            operationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            operationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            operationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            operationBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        operationBar.selectedCrop = { [weak self] in
            guard let self = self else { return }
            
            self.removePreviousView()
            
            let vc = Mantis.cropCustomizableViewController(image: self.processedWholeImage!)
            self.addChild(vc)
            self.stageView.addSubview(vc.view)
            vc.didMove(toParent: self)
                        
            self.currentProcessorViewController = vc
        }
        
        operationBar.selectedFilter = { [weak self] in
            guard let self = self else { return }
            
            self.removePreviousView()
            
            let vc = Impression.createFilterViewController(image: self.processedCroppedImage!, delegate: nil)
            self.addChild(vc)
            self.stageView.addSubview(vc.view)
            vc.didMove(toParent: self)
            
            self.currentProcessorViewController = vc
        }
        
        operationBar.showPreview = {[weak self] in
            guard let self = self else { return }
            
            self.removeCurrentProcessorViewController()
            
            guard let processedCroppedImage = self.processedCroppedImage else {
                return
            }
            
            if self.previewView == nil {
                self.previewView = PreviewView(image: processedCroppedImage)
                self.previewView.translatesAutoresizingMaskIntoConstraints = false
                self.stageView.addSubview(self.previewView)
                self.previewView.fillSuperview()
            }
            
            self.previewView.image = processedCroppedImage
        }
        
        operationBar.selectDefault()
    }
    
    func removePreviousView() {
        removePreview()
        removeCurrentProcessorViewController()
    }
    
    private func removePreview() {
        if previewView != nil {
            previewView.removeFromSuperview()
        }
    }
    
    private func removeCurrentProcessorViewController() {
        currentProcessorViewController?.willMove(toParent: nil)
        currentProcessorViewController?.removeFromParent()
        currentProcessorViewController?.view.removeFromSuperview()
    }
    
    func takeoverProcessedImage(_ image: UIImage) {
        processedWholeImage = image
    }
    
    func alterProcessor() {
        
    }

    func confirmCancel() {
        guard let image = originalImage else {
            return
        }
        delegate?.dahliaViewControllerDidFailedToProcess(self, originalImage: image)
    }
    
    func cancel() {
        confirmCancel()
    }
    
    func confirm() {
        guard let image = processedCroppedImage else {
            return
        }
        delegate?.dahliaViewControllerDidProcess(self, processedImage: image)
    }
}
