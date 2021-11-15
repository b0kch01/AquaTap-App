//
//  Defaults.swift
//  Defaults
//
//  Created by Nathan Choi on 9/27/21.
//

import Foundation


let Defaults = UserDefaults.standard

struct UD {

    /// Returns string value
    static func `get`(_ key: String, fallback: String?=nil) -> String {
        return Defaults.string(forKey: key) ?? fallback ?? ""
    }

    /// Returns double value
    static func `get`(_ key: String, fallback: Double?=nil) -> Double {
        return Defaults.double(forKey: key) ?? fallback ?? 0
    }

}
