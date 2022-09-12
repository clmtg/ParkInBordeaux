//
//  EndpointFilters.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 31/08/2022.
//

import Foundation

//Give the ability to encode parameters filters for the related API call to to the car park service
// MARK: - FiltersInfo
public struct EndpointFilters: Encodable {
    var filters = [[String: String]]()
    
    enum CodingKeys: String, CodingKey {
        case filters = "$and"
    }
}
