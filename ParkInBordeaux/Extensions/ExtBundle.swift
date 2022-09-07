//
//  ExtBundle.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 07/09/2022.
//

import Foundation

extension Bundle {
    /// Extract data from a json file
    /// - Parameter name: json file name
    /// - Returns: data
    func dataFromJson(_ name: String) -> Data {
        guard let mockURL = url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: mockURL) else {
            fatalError("Failed to load \(name) from bundle.")
        }
        return data
    }
}
