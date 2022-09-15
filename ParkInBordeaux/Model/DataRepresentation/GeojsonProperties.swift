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
    var taType: String
    var npTotal: Int?
    var libres: Int?
    var adresse: String?
    var infor: String?
    var exploit: String?
    var npPmr: Int?
    var npVeltot: Int?
    var npStlav: Int?
    var npCovoit: Int?
    var npVle: Int?
    var np2rmot: Int?
    
}
