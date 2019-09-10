//
//  FeatureCandidates.swift
//  Dahlia
//
//  Created by Echo on 9/9/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import Foundation

public struct FeatureCandidates: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static public let crop = FeatureCandidates(rawValue: 1 << 0)
    static public let filter = FeatureCandidates(rawValue: 1 << 1)
    
    static public let `default`: FeatureCandidates = [crop, filter]
    static public let all: FeatureCandidates = [crop, filter]
}
