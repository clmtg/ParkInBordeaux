//
//  ExtString.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
