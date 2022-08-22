//
//  CarParksClusterViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 22/08/2022.
//

import UIKit
import MapKit

class CarParksClusterAnnotationView: MKAnnotationView {
    
    // MARK: - Initializer
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    // SEBASTIEN CHECK REQUIRED : explanation regarding required and optional init ?!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    /// Prepare the cluster of annotation based on the car park type and related avaibility
    override func prepareForDisplay() {
        super.prepareForDisplay()
        if let cluster = annotation as? MKClusterAnnotation {
            let totalCarParks = cluster.memberAnnotations.count
            image = drawUnicycleCount(count: cluster.memberAnnotations.count)
            
        }
    }
    
    private func drawUnicycleCount(count: Int) -> UIImage {
        return drawRatio(0, to: count, fractionColor: nil, wholeColor: UIColor.systemRed)
    }
    
    private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

            // Fill pie with fractionColor
            fractionColor?.setFill()
            let piePath = UIBezierPath()
            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole),
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
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
    
    private func count(carParkType type: CarParkMapAnnotation.CarParkType) -> Int {
        guard let cluster = annotation as? MKClusterAnnotation else {
            return 0
        }

        return cluster.memberAnnotations.filter { member -> Bool in
            guard let carPark = member as? CarParkMapAnnotation else {
                fatalError("Found unexpected annotation type")
            }
            return carPark.type == type
        }.count
    }
    
    
    
    
    
}
