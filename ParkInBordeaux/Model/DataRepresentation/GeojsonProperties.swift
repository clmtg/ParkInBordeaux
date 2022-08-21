//
//  GeojsonProperties.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation

// MARK: - GeojsonProperties
struct GeojsonProperties: Decodable{
    
    /// Car park name
    let nom: String?
    
    /// Car park state (e.g.: Open, Close, Subscribers only, etc...)
    let etat: String?
}
