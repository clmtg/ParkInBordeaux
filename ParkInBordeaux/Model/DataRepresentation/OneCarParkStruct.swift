//
//  OneCarParkStruct.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation
import MapKit

typealias CarParks = [OneCarParkStruct]

struct OneCarParkStruct {
    // MARK: - Vars
    /// Car park id
    var id: String?
    /// The latitude and longitude associated with the car park
    var location: CLLocationCoordinate2D?
    /// Car park properties 
    var properties: GeojsonProperties?
    
    var carSpotsFree: Int {
        guard let properties = properties else {
            return 0
        }
        return properties.libres ?? 0
    }
    
    var carSpotsAmount: Int {
        guard let properties = properties else {
            return 0
        }
        return properties.np_total ?? 0
    }
    
    // MARK: - initializer
    init(for id: String?, location: CLLocationCoordinate2D?, properties: GeojsonProperties?) {
        self.id = id
        self.location = location
        self.properties = properties
    }
}
    


