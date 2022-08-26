//
//  CarParksClusterAnnotationViewMaker.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 23/08/2022.
//

import UIKit
import MapKit

// TODO: Sebastien check needed

/**
 Comments :
 - MKAnnotationView is a view and is needed to display an annotaion (type : MKAnnotation).
 - MKMarkerAnnotationView provides an MKAnnotationView using the balloon shaped to display an annotaion (type : MKAnnotation).
 - An annotaion (type : MKAnnotation) is always needed.
 - A cluster is an annotaion
 */

/// Used to display a cluster of CarParkMapAnnotation
class CarParksClusterAnnotationViewMaker: MKMarkerAnnotationView {
    
    static let reuseID = "clusterAnnotation"
    
    // MARK: - Initializer
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    // SEBASTIEN CHECK REQUIRED : explanation regarding required and optional init ?!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    override func prepareForDisplay() {
        super.prepareForDisplay()
        //markerTintColor = UIColor.systemFill
        displayPriority = .defaultLow
        animatesWhenAdded = true
    }

}
