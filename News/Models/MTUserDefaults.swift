//
//  MTUserDefaults.swift
//  News
//
//  Created by Abdelrahman on 31/07/2023.
//

import Foundation



struct MTUserDefaults{
    static var shared = MTUserDefaults()
    
    var theme:Theme{
        get{
            return Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
