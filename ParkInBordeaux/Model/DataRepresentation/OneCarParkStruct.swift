//
//  OneCarParkStruct.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation
import MapKit

struct OneCarParkStruct {
    
    // MARK: - Vars
    /// Car park id
    var id: String?
    /// The latitude and longitude associated with the car park
    var location: CLLocationCoordinate2D?
    /// Car park properties 
    var properties: GeojsonProperties?
    
    // MARK: - initializer
    init(for id: String?, location: CLLocationCoordinate2D?, properties: GeojsonProperties?) {
        self.id = id
        self.location = location
        self.properties = properties
    }
}
    


