//
//  EndpointFilters.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 31/08/2022.
//

import Foundation

// MARK: - FiltersInfo
public struct EndpointFilters: Encodable {
    var filters = [[String: String]]()
    
    enum CodingKeys: String, CodingKey {
        case filters = "$and"
    }
}
