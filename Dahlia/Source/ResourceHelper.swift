//
//  LocalizedHelper.swift
//  Dahlia
//
//  Created by Echo on 9/10/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import Foundation

struct ResourceHelper {
    static private(set) var bundle: Bundle? = {
        guard let bundle = Bundle(identifier: "org.cocoapods.Dahlia") else {
            return nil
        }
        
        if let url = bundle.url(forResource: "Resource", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return bundle
        }
        return nil
    } ()

    
    static func getString(_ key: String, value: String? = nil, comment: String = "") -> String {
        let value = value ?? key
        
        var text = value
        if let bundle = ResourceHelper.bundle {
            text = NSLocalizedString(key, tableName: "MantisLocalizable", bundle: bundle, value: value, comment: comment)
        }
        return text
    }
}
