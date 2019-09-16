//
//  PreviewView.swift
//  Dahlia
//
//  Created by Echo on 9/15/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

class PreviewView: UIView {

    var image: UIImage? {
        didSet {
            setupImageView()
        }
    }
    
    var imageView: UIImageView!
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        self.setupImageView()
    }
    
    func setupImageView() {
        if imageView == nil {
            imageView = UIImageView(image: image!)
            addSubview(imageView)
            
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.fillSuperview()
        }
        
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }    
}
