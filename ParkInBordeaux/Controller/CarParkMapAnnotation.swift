//
//  CarParkDataSet.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation
import MapKit

// TODO: Sebastien check needed
/**
 Comments :
 - MKAnnotationView is a view and is needed to display an annotaion (type : MKAnnotation).
 - MKMarkerAnnotationView provides an MKAnnotationView using the balloon shaped to display an annotaion (type : MKAnnotation).
 - An annotaion (type : MKAnnotation) is always needed.
 - A cluster is an annotaion
 */

final class CarParkMapAnnotation: NSObject, MKAnnotation {
    
    static let reuseID = "carParkAnnotation"
    
    enum CarParkType: Int, Decodable {
        case free
        case membershipNeeded
        case pricePerHour
        case parkAndRide
        case priceOnStreet
        case otherPrice
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var carParkInfo: OneCarParkStruct?
    var type: CarParkType = .pricePerHour
    
    init(for coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, carParkInfo: OneCarParkStruct?) {
        self.coordinate = coordinate
        self.title = title?.capitalizingFirstLetter()
        self.subtitle = "\(carParkInfo!.carSpotsFree) / \(carParkInfo!.carSpotsAmount)"
        self.carParkInfo = carParkInfo
    }
}
