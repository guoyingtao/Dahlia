//
//  OperationBar.swift
//  Dahlia
//
//  Created by Echo on 9/10/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

enum OperationStatus {
    case preview
    case crop
    case filter
}

class OperationBar: UIView {

    var selectedCancel = {}
    var selectedDone = {}
    var selectedCrop = {}
    var selectedFilter = {}
    var showPreview = {}
    var applyCrop = {}
    var applyFilter = {}
    
    var status: OperationStatus = .preview
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(didCancel), for: .touchUpInside)
        return button
    } ()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(didDone), for: .touchUpInside)
        return button
    } ()
    
    lazy var cropButton: UIToggleButton = {
        let button = UIToggleButton()
        button.onImage = UIImage(named: "crop.png", in: getBundle(), compatibleWith: nil)
        button.offImage = UIImage(named: "crop.png", in: getBundle(), compatibleWith: nil)
        button.addTarget(self, action: #selector(didSelectCrop), for: .touchUpInside)
        return button
    } ()

    
    lazy var filterButton: UIToggleButton = {
        let button = UIToggleButton()
        button.onImage = UIImage(named: "filter.png", in: getBundle(), compatibleWith: nil)
        button.offImage = UIImage(named: "filter.png", in: getBundle(), compatibleWith: nil)
        button.addTarget(self, action: #selector(didSelectFilter), for: .touchUpInside)
        return button
    } ()

    
    var buttons: [UIButton] = []
    
    private var optionButtonStackView: UIStackView?
    
    private func getBundle() -> Bundle? {
        print(NSHomeDirectory())
        
        return ResourceHelper.bundle
    }
    
    func createToolbarUI() {
        buttons.append(cancelButton)
        buttons.append(cropButton)
        buttons.append(filterButton)
        buttons.append(doneButton)
        
        createButtonContainer()
        addButtonsToContainer(buttons: buttons)
    }
    
    private func createButtonContainer() {
        optionButtonStackView = UIStackView()
        addSubview(optionButtonStackView!)
        
        optionButtonStackView?.distribution = .equalCentering
        optionButtonStackView?.isLayoutMarginsRelativeArrangement = true
        optionButtonStackView?.translatesAutoresizingMaskIntoConstraints = false
        optionButtonStackView?.fillSuperview()
    }
    
    private func addButtonsToContainer(buttons: [UIButton]) {
        buttons.forEach{
            optionButtonStackView?.addArrangedSubview($0)
        }
    }
    
    @objc func didDone() {
        switch status {
        case .crop:
            applyCrop()
        case .filter:
            applyFilter()
        default:
            ()
        }
        selectedDone()
    }
    
    @objc func didCancel() {
        selectedCancel()
    }
    
    @objc func didSelectCrop() {
        if cropButton.isOn {
            if filterButton.isOn {
                applyFilter()
                filterButton.isOn = false
            }
            
            selectedCrop()
            status = .crop
        } else {
            applyCrop()
            showPreview()
            status = .preview
        }
    }
    
    @objc func didSelectFilter() {
        if filterButton.isOn {
            if cropButton.isOn {
                applyCrop()
                cropButton.isOn = false
            }
            
            selectedFilter()
            status = .filter
        } else {
            applyFilter()
            showPreview()
            status = .preview
        }
    }
    
    func selectDefault() {
        showPreview()
        status = .preview
    }
}
