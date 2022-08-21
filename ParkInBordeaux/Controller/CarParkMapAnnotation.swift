//
//  CarParkDataSet.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation
import MapKit

final class CarParkMapAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var carParkInfo: OneCarParkStruct?
    
    init(for coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, carParkInfo: OneCarParkStruct?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.carParkInfo = carParkInfo
    }
}
