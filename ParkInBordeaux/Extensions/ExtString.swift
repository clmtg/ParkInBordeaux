//
//  ExtString.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation

extension String {
    /// Set the affected string with the first letter in uppercase and then remaining ones in lowercase
    /// - Returns: Formarted affected string
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}


