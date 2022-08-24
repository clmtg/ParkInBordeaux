//
//  GeojsonProperties.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation

// MARK: - GeojsonProperties
struct GeojsonProperties: Decodable{
    
    var nom: String?
    var etat: String?
    var ident: String?
    var ta_type: String
    var np_total: Int?
    var libres: Int?
    var adresse: String?
    
}
