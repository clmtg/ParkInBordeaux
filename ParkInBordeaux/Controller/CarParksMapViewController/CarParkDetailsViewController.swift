//
//  CarParkDetailsViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 23/08/2022.
//

import UIKit
import MapKit

/// View controller for the view displaying detailed information relqted to a  specific car park
class CarParkDetailsViewController: UIViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
        setUpMapViewBasedOnDetails()
    }
    
    // MARK: - Vars
    /// Data related to the affected car park to display
    var affectedCarpark: CarParkMapAnnotation?
    /// Affected car park name
    var carParkName: String {
        guard let name = affectedCarpark?.carParkInfo?.properties?.nom else {
            return ""
        }
        return name
    }
    /// Affected car park location
    var carParkLocation: CLLocationCoordinate2D {
        guard let location = affectedCarpark?.coordinate else {
            return CLLocationCoordinate2D(latitude: 44.84203155780349, longitude: -0.5744705263091234)
        }
        return location
    }
    /// Amount of car space within the affected car park (occupied + available)
    var carParkSpotTotal: Int {
        guard let amount = affectedCarpark?.carParkInfo?.carSpotsAmount else {
            return 0
        }
        return amount
    }
    /// Amount of available car space within the affected car park
    var carParkSpotFree: Int {
        guard let amount = affectedCarpark?.carParkInfo?.carSpotsFree else {
            return 0
        }
        return amount
    }
    
    // MARK: - IBOutlet
    /// MapView Controller used to display the exact location of the affected car park
    @IBOutlet weak var mapView: MKMapView!
    ///  Label for the affected car park name
    @IBOutlet weak var carPakNameLabel: UILabel!
    /// Label used to display the amount of car spot within the affected car park
    @IBOutlet weak var carSpotTotalAmountLabel: UILabel!
    ///  Label used to display the amount of available car spots within the car park
    @IBOutlet weak var carSpotFreeAmountLabel: UILabel!
    /// Label used to display car park postal address
    @IBOutlet weak var carParkAddress: UILabel!
    
    // MARK: - IBAction
    ///  Performed when user select the "Annuler" button. This would dismiss the modal detailed view
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /// Performed when user select the "S'y rendre" button. This would use the openWithMap function to launch Apple Maps
    @IBAction func didTapGoButton(_ sender: Any) {
        openWithMap()
    }
    
    // MARK: - Functions
    /// Set the labels with the affected car park data. This is performed when the view has been loaded (viewDidLoad())
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
