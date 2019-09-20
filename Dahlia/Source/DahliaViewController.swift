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

public protocol DahliaViewControllerDelegate {
    func dahliaViewControllerDidProcess(_ dahliaViewController: DahliaViewController, processedImage: UIImage)
    func dahliaViewControllerDidFailedToProcess(_ dahliaViewController: DahliaViewController, originalImage: UIImage)
    func dahliaViewControllerDidCancel(_ dahliaViewController: DahliaViewController, originalImage: UIImage)
}

public extension DahliaViewControllerDelegate {
    func dahliaViewControllerDidFailedToProcess(_ dahliaViewController: DahliaViewController, originalImage: UIImage) {
        
    }
    
    func dahliaViewControllerDidCancel(_ dahliaViewController: DahliaViewController, originalImage: UIImage) {
        
    }
}

public class DahliaViewController: UIViewController {
    
    public var originalImage: UIImage?
    public var processedWholeImage: UIImage?
    public var croppedImage: UIImage?
    public var processedCroppedImage: UIImage?
    public var config = Dahlia.Config()
    public var delegate: DahliaViewControllerDelegate?
    
    private var processed = false
    private var operationBar: OperationBar!
    private var stageView: UIView!
    private var currentProcessorViewController: UIViewController?
    private var previewView: PreviewView!
    private var cropViewController: CropViewController?
    private var filterViewController: FilterViewController?
    
    init?(image: UIImage, config: Dahlia.Config) {
        self.originalImage = image
        self.config = config
        
        guard let image = originalImage, let cgImage = image.cgImage?.copy() else {
            return nil
        }
        
        processedWholeImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Magic", style: .plain, target: nil, action: nil)
        
        stageView = UIView()
        stageView.backgroundColor = .black
        stageView.clipsToBounds = true
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
            
            if self.cropViewController == nil {
                self.cropViewController = Mantis.cropCustomizableViewController(image: self.processedWholeImage!)
            } else {
                self.cropViewController?.image = self.processedWholeImage!
            }            
            
            self.addChild(self.cropViewController!)
            self.stageView.addSubview(self.cropViewController!.view)
            self.cropViewController!.didMove(toParent: self)
            
            self.cropViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cropViewController!.view.fillSuperview()
                        
            self.currentProcessorViewController = self.cropViewController!
        }
        
        operationBar.selectedFilter = { [weak self] in
            guard let self = self else { return }
            
            self.removePreviousView()
            
            if self.filterViewController == nil {
                self.filterViewController = Impression.createCustomFilterViewController(image: self.getCroppedImage()!, delegate: nil)
            } else {
                self.filterViewController?.image = self.getCroppedImage()!
            }
            
            self.addChild(self.filterViewController!)
            self.stageView.addSubview(self.filterViewController!.view)
            self.filterViewController!.didMove(toParent: self)
            
            self.filterViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.filterViewController!.view.fillSuperview()
            
            self.currentProcessorViewController = self.filterViewController!
        }
        
        operationBar.showPreview = {[weak self] in
            guard let self = self else { return }
            
            self.removeCurrentProcessorViewController()
            
            guard let processedCroppedImage = self.getProcessedCroppedImage() else {
                return
            }
            
            if self.previewView == nil {
                self.previewView = PreviewView(image: processedCroppedImage)
                self.previewView.translatesAutoresizingMaskIntoConstraints = false
            }
            
            self.previewView.image = processedCroppedImage
            self.stageView.addSubview(self.previewView)
            self.previewView.fillSuperview()
        }
        
        operationBar.applyCrop = { [weak self] in
            guard let self = self else { return }
            guard let image = self.cropViewController?.process(self.originalImage!) else {
                return
            }
            
            self.croppedImage = image
        }
        
        operationBar.applyFilter = { [weak self] in
            guard let self = self else { return }
            guard let processedCroppedImage = self.filterViewController?.process( self.getCroppedImage()!) else {
                return
            }
            
            self.processedCroppedImage = processedCroppedImage
            
            guard let processedWholeImage = self.filterViewController?.process( self.originalImage!) else {
                return
            }
            
            self.processedWholeImage = processedWholeImage
        }
        
        operationBar.selectedCancel = { [weak self] in
            self?.cancel()
        }
        
        operationBar.selectedDone = { [weak self] in
            self?.confirm()
        }
        
        operationBar.selectDefault()
    }
    
    func getCroppedImage() -> UIImage? {
        if croppedImage == nil {
            return processedWholeImage
        }
        
        return croppedImage
    }
    
    func getProcessedCroppedImage() -> UIImage? {
        if processedCroppedImage == nil {
            return getCroppedImage()
        }
        
        return processedCroppedImage
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
        guard let image = getProcessedCroppedImage() else {
            return
        }
        delegate?.dahliaViewControllerDidProcess(self, processedImage: image)
    }
}
