//
//  CarParkDataSet.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation
import MapKit

final class CarParkMapAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Vars
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var ident: String?
    var state: String?
    
    // MARK: - initializer
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, ident: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.ident = ident
    }
}
