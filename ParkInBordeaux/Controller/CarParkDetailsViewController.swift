//
//  CarParkDetailsViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 23/08/2022.
//

import UIKit
import MapKit

class CarParkDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
        setUpMapViewBasedOnDetails()
    }
    
    // MARK: - Vars
    var affectedCarpark: CarParkMapAnnotation?
    
    var carParkName: String {
        guard let name = affectedCarpark?.carParkInfo?.properties?.nom else {
            return ""
        }
        return name
    }
    
    var carParkLocation: CLLocationCoordinate2D {
        guard let location = affectedCarpark?.coordinate else {
            return CLLocationCoordinate2D(latitude: 44.84203155780349, longitude: -0.5744705263091234)
        }
        return location
    }
    
    var carParkSpotTotal: Int {
        guard let amount = affectedCarpark?.carParkInfo?.carSpotsAmount else {
            return 0
        }
        return amount
    }
    
    var carParkSpotFree: Int {
        guard let amount = affectedCarpark?.carParkInfo?.carSpotsFree else {
            return 0
        }
        return amount
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var carPakNameLabel: UILabel!
    @IBOutlet weak var carSpotTotalAmountLabel: UILabel!
    @IBOutlet weak var carSpotFreeAmountLabel: UILabel!
    @IBOutlet weak var carParkAddress: UILabel!
    
    // MARK: - IBAction
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapGoButton(_ sender: Any) {
        openWithMap()
    }
    
    // MARK: - Functions
    
    func loadDetails() {
        carPakNameLabel.text = carParkName
        carParkAddress.text = affectedCarpark?.carParkInfo?.properties?.adresse
        carSpotTotalAmountLabel.text = "Nombre de place total : \(carParkSpotTotal)"
        carSpotFreeAmountLabel.text = "Places disponible : \(carParkSpotFree)"
    }
    
    /// Setup the MapView controller for the affected car park. (Making sure the view is centered on the car parck, specific zoom, etc ...)
    func setUpMapViewBasedOnDetails(){
        mapView.layer.cornerRadius = 10.0;
        let region = MKCoordinateRegion(center: carParkLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(affectedCarpark!)
    }
    
    /// Used when user tap on "Go" button. This would open the built-in Maps app and attempt to display an itinerary using thr driving mode
    func openWithMap() {
        let placeMark = MKPlacemark(coordinate: carParkLocation)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = carParkName
        mapItem.pointOfInterestCategory = .parking
        let launchOption = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
        mapItem.openInMaps(launchOptions: launchOption)
        
    }
    
    
}
