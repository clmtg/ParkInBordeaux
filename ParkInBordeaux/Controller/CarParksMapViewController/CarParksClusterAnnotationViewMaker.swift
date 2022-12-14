//
//  CarParksClusterAnnotationViewMaker.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 23/08/2022.
//

import UIKit
import MapKit

/// Used to display a cluster of CarParkMapAnnotation
class CarParksClusterAnnotationViewMaker: MKMarkerAnnotationView {
    
    /// Id used to reused MapAnnotation. Performance related (avoid to create new annotation again and agin whereas annotation could be reused )
    static let reuseID = "clusterAnnotation"
    
    // MARK: - Initializer
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func prepareForDisplay() {
        super.prepareForDisplay()
        markerTintColor = UIColor(named: "balloonAnnotation")
        displayPriority = .defaultLow
        animatesWhenAdded = true
    }

}
