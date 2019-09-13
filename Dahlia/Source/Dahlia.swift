//
//  Dahlia.swift
//  Dahlia
//
//  Created by Echo on 9/9/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import Foundation

public func createDahliaViewController(config: Dahlia.Config = Dahlia.Config()) -> UIViewController? {
    guard let vc = createDahliaViewController() else { return nil }
    let unc = UINavigationController(rootViewController: vc)
    return unc
}

public struct Config {
    public var features: FeatureCandidates = .default
    
    public init() {
    }
}
