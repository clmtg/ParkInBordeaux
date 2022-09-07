//
//  CarParkDataSet.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation
import MapKit

/// Representation of a car park annotation. This is the data source of an annotation view controller
final class CarParkMapAnnotation: NSObject, MKAnnotation {
    
    /// ID used to reuse annotation within the view controller. Performance related: In order to avoid overcreation of annotation view
    static let reuseID = "carParkAnnotation"
    
    /// Type of car park
    enum CarParkType: Int, Decodable {
        case free
        case membershipNeeded
        case pricePerHour
        case parkAndRide
        case priceOnStreet
        case otherPrice
    }
    
    // MARK: - Vars
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var carParkInfo: OneCarParkStruct?
    var type: CarParkType = .pricePerHour
    
    // MARK: - Initializer
    init(for coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, carParkInfo: OneCarParkStruct?) {
        self.coordinate = coordinate
        self.title = title?.capitalizingFirstLetter()
        if carParkInfo!.carSpotsFree == 0 {
            self.subtitle = "Aucune place disponible"
        }
        else {
            self.subtitle = "\(carParkInfo!.carSpotsFree) places disponible"
        }
        self.carParkInfo = carParkInfo
    }
}
