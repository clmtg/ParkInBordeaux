//
//  CarParkMapAnnotationView.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 23/08/2022.
//

import UIKit
import MapKit

/// Used to display a CarParkAnnotation within the MapViewController. This AnnotationView does dispay a camembert graph related to the occupancy
class CarParkMapAnnotationView: MKAnnotationView {
    
    static let reuseID = "carParkAnnotation"
    
    // MARK: - Initializer
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
        clusteringIdentifier = CarParksClusterAnnotationViewMaker.reuseID
        canShowCallout = true
        let rightButton = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = rightButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
            willSet {
                clusteringIdentifier = CarParksClusterAnnotationViewMaker.reuseID
            }
        }
    
    // MARK: - Functions
    /// Prepare the annotation to be display including the custom "shape" generation
    override func prepareForDisplay() {
        super.prepareForDisplay()
        if annotation is CarParkMapAnnotation {
                image = drawRatio(carSpotsFree: getCarSpotsFree(), carSpotsGlobal: getCarSpotsAvailable(), fractionColor: UIColor.systemTeal, wholeColor: UIColor.systemOrange)
        }
    }
    
    /// Generate the camembert graph to be used arround the annotation. It should be used to display car par occupency
    /// - Parameters:
    ///   - carSpotsFree: Amount of car spot available within the affected cluster
    ///   - carSpotsGlobal: Global amount of car spot (used + free) within the affected cluster
    ///   - fractionColor: Color to be used for the value. (e.g. 3 out of 5 (Color for the value "3"))
    ///   - wholeColor: Based color for the camembert graph
    /// - Returns: Image of the generated camembert graph
    private func drawRatio(carSpotsFree: Int, carSpotsGlobal: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

            // Fill pie with fractionColor
            fractionColor?.setFill()
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(carSpotsFree)) / CGFloat(carSpotsGlobal),
                           clockwise: true)
            piePath.addLine(to: CGPoint(x: 20, y: 20))
            piePath.close()
            piePath.fill()

            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            
            let text = "P"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
    

    
    private func getCarSpotsFree() -> Int {
        
        guard let annotation = annotation as? CarParkMapAnnotation,
              let amountFreeSpot = annotation.carParkInfo?.carSpotsFree else {
            return 0
        }
        return amountFreeSpot
    }
    
    private func getCarSpotsAvailable() -> Int {
        
        guard let annotation = annotation as? CarParkMapAnnotation,
              let amountFreeSpot = annotation.carParkInfo?.carSpotsAmount else {
            return 0
        }
        return amountFreeSpot
    }
}
