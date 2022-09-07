//
//  CarParksServiceError.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation

//Enumeration which list the error case for the services used within the Baluchon app
enum CarParksServiceError: Error {
    case corruptData
    case unexpectedResponse
    case undecodableGeojson
    case networkCallFailed
    case noCarParkWithinArea
}

extension CarParksServiceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .corruptData: return "CorruptData - Les données fournies sont illisible."
        case .unexpectedResponse: return "ParkInBordeaux semble founir une reponse incoherente."
        case .undecodableGeojson: return "GeoJSON - Les données fournies ne respected pas le standart Geojson"
        case .networkCallFailed: return "L'appel réseau a échoué"
        case .noCarParkWithinArea: return "Aucun parking n'est disponible dans cette zone géographique"
        }
    }
}
