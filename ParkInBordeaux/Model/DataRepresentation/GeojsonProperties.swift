//
//  GeojsonProperties.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation

// MARK: - GeojsonProperties
struct GeojsonProperties: Decodable{
    let ident: String?
    let nom: String?
    let etat: String?
}
