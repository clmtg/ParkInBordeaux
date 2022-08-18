//
//  CarParksMapViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import UIKit
import MapKit

final class CarParksMapViewController: UIViewController {
    
    // MARK: - LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCarParksMapView()
        loadCarParksDataSet()
    }
    
    // MARK: - Vars
    let carParkCore = CarParksCoreService()
    
    // MARK: - IBOutlet
    @IBOutlet weak var carParksMapViewController: MKMapView!
    
    // MARK: - IBAction
    
    // MARK: - Functions
    
    private func setCarParksMapView() {
        let cityCenterLocation = CLLocationCoordinate2D(latitude: 44.84203155780349, longitude: -0.5744705263091234)
        let region = MKCoordinateRegion(center: cityCenterLocation, latitudinalMeters: 7000, longitudinalMeters: 7000)
        carParksMapViewController.setRegion(region, animated: true)
        carParksMapViewController.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 40000)
        carParksMapViewController.setCameraZoomRange(zoomRange, animated: true)
        
        carParksMapViewController.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CarParkMapAnnotation.self))
        
        
    }
    
    private func loadCarParksDataSet() {
        carParkCore.getCarParksAvailabilityPins { resultAvailability in
            guard case let .success(carParksAnnotations) = resultAvailability else {
                return
            }
            self.carParksMapViewController.addAnnotations(carParksAnnotations)
        }
    }
}


// MARK: - Extensions
extension CarParksMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Checing if affected annotation is related to current user location.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
            return nil
        }
        
        let identifier = NSStringFromClass(CarParkMapAnnotation.self)
        let reusedView = carParksMapViewController.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        if let markerAnnotationView = reusedView as? MKMarkerAnnotationView {
            markerAnnotationView.markerTintColor = UIColor.systemOrange
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
            return markerAnnotationView
        }
        return reusedView
    }
    
}
