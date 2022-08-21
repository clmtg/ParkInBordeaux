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
    
    func loadCarParksDataSet() {
        DispatchQueue.main.async {
        self.carParkCore.getLatestUpdate { resultCarParkData in
            guard case .success(let carParksData) = resultCarParkData else {
                if case .failure(let errorInfo) = resultCarParkData {
                    self.displayAnAlert(title: "Oups", message: errorInfo.description, actions: nil)
                }
                return
            }
            carParksData.forEach { oneCarPark in
                if let location = oneCarPark.location, let properties = oneCarPark.properties {
                    
                        self.carParksMapViewController.addAnnotation(CarParkMapAnnotation(for: location ,
                                                                                          title: properties.nom ?? "No name",
                                                                                          subtitle: properties.etat ?? "Inconnu",
                                                                                          carParkInfo: oneCarPark))
                    }
                }
            }
        }
    }
}

// MARK: - Extensions
extension CarParksMapViewController: MKMapViewDelegate {
    
}
