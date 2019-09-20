//
//  Dahlia.swift
//  Dahlia
//
//  Created by Echo on 9/9/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import Foundation

public func createDahliaViewController(image: UIImage, config: Dahlia.Config = Dahlia.Config(), delegate: DahliaViewControllerDelegate? = nil) -> UIViewController? {
    guard let vc = DahliaViewController(image: image, config: config) else { return nil }
    vc.delegate = delegate
    let unc = UINavigationController(rootViewController: vc)
    return unc
}

public struct Config {
    public var features: FeatureCandidates = .default
    
    public init() {
    }
}
