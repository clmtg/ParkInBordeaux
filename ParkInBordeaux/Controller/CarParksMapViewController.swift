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
    
    /// Set the MKMapView which will be used within the view. (Region limit, zoom limit, initial location, etc ...)
    private func setCarParksMapView() {
        let cityCenterLocation = CLLocationCoordinate2D(latitude: 44.84203155780349, longitude: -0.5744705263091234)
        let region = MKCoordinateRegion(center: cityCenterLocation, latitudinalMeters: 7000, longitudinalMeters: 7000)
        carParksMapViewController.setRegion(region, animated: true)
        carParksMapViewController.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 40000)
        carParksMapViewController.setCameraZoomRange(zoomRange, animated: true)
        carParksMapViewController.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CarParkMapAnnotation.self))
    }
    
    /// Load the data related to the car parks availability into the MKMapView
    private func loadCarParksDataSet() {
        carParkCore.getCarParksAvailabilityAnnotation { resultAnnotations in
            DispatchQueue.main.async {
                guard case .success(let annotationsData) = resultAnnotations else {
                    self.displayAnAlert(title: "Opps", message: "There an issue", actions: nil)
                    return
                }
                self.carParksMapViewController.addAnnotations(annotationsData)
            }
        }
    }
    
    private func getBallonShapeColor(state: String) -> UIColor {
        var colorToUse = UIColor.systemMint
        switch state {
        case "LIBRE":
            colorToUse = UIColor.systemGreen
        case "OUVERT":
            colorToUse = UIColor.systemOrange
        case "FERME":
            colorToUse = UIColor.systemRed
        case "COMPLET":
            colorToUse = UIColor.systemRed
        default:
            colorToUse = UIColor.systemGreen
        }
        return colorToUse
    }
}

// MARK: - Extensions
extension CarParksMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let identifier = NSStringFromClass(CarParkMapAnnotation.self)
        let view = carParksMapViewController.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        if let markerAnnotationView = view as? MKMarkerAnnotationView,
           let currentAnnotation = annotation as? CarParkMapAnnotation {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = getBallonShapeColor(state: currentAnnotation.state!)
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
            return markerAnnotationView
        }
        return view
    }
    
    /*
    
    /// Called whent he user taps the disclosure button in the bridge callout.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let detailNavController = storyboard?.instantiateViewController(withIdentifier: "CarParkDetailsViewController") {
            detailNavController.modalPresentationStyle = .popover
            let presentationController = detailNavController.popoverPresentationController
            presentationController?.permittedArrowDirections = .any
            presentationController?.sourceRect = control.frame
            presentationController?.sourceView = control
            present(detailNavController, animated: true, completion: nil)
        }
    }
     */
}

// SEBASTIEN CHECK REQUIRED : Should annotation generation be part of the model or the view controller ?
