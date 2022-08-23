//
//  CarParkMapAnnotationMaker.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 22/08/2022.
//

import UIKit
import MapKit

/**
 Comments :
 - MKAnnotationView is a view and is needed to display an annotaion (type : MKAnnotation).
 - MKMarkerAnnotationView provides an MKAnnotationView using the balloon shaped to display an annotaion (type : MKAnnotation).
 - An annotaion (type : MKAnnotation) is always needed.
 - A cluster is an annotaion
 */

class CarParkMapAnnotationMaker: MKMarkerAnnotationView {
    
    static let reuseID = "carParkAnnotation"

    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = CarParksClusterAnnotationView.reuseID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.systemTeal
        animatesWhenAdded = true
        canShowCallout = true
        let rightButton = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = rightButton
        glyphImage = #imageLiteral(resourceName: "logoParking")
    }
}
