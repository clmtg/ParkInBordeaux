//
//  CarParkDataSet.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation
import MapKit

final class CarParkMapAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Vars - Mandatory
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    // MARK: - Vars - Additional data
    var state: String?
    
    // MARK: - initializer
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, state: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = state?.capitalizingFirstLetter()
        self.state = state
    }
}
