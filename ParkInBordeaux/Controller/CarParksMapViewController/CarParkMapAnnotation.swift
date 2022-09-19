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
    
    /// Type of car park used for display by the related annotation
    enum CarParkType: Int, Decodable {
        case free
        case membershipNeeded
        case pricePerHour
        case parkAndRide
        case priceOnStreet
        case otherPrice
    }
    
    // MARK: - Vars
    /// Location of the annotation
    var coordinate: CLLocationCoordinate2D
    /// Annotation title
    var title: String?
    /// Annotation subtitle
    var subtitle: String?
    /// Affected car park info. This would be used to display info within the  related annotation
    var carParkInfo: OneCarParkStruct?
    var type: CarParkType = .pricePerHour
    
    // MARK: - Initializer
    init(for coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, carParkInfo: OneCarParkStruct?) {
        self.coordinate = coordinate
        self.title = title?.capitalizingFirstLetter()
        guard let dataCarPark = carParkInfo else { return }
        self.carParkInfo = dataCarPark
        guard !dataCarPark.isFull, !dataCarPark.isClosed else {
            self.subtitle = dataCarPark.status
            return
        }
        self.subtitle = "\(carParkInfo!.freeSpot) places disponibles"
    }
}
