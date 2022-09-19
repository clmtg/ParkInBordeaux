//
//  CarParkDetailsViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 23/08/2022.
//

import UIKit
import MapKit
import Mixpanel

/// View controller for the view displaying detailed information relqted to a  specific car park
class CarParkDetailsViewController: UIViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView(affectedCarpark)
        loadDetails()
        sendEvent()
    }
    
    // MARK: - Vars
    /// Data related to the affected car park to display
    var affectedCarpark: CarParkMapAnnotation?
    
    // MARK: - IBOutlet
    /// MapView Controller used to display the exact location of the affected car park
    @IBOutlet weak var mapView: MKMapView!
    /// Top Stack view listing views related to car park infos
    @IBOutlet weak var carParkInfoStackViewTop: UIStackView!
    /// Bottom Stack view listing views related to car park infos
    @IBOutlet weak var carParkInfoStackViewBottom: UIStackView!
    /// Stack view listing asset for the services available within the affe ted car park
    @IBOutlet weak var carParkServicesSatck: UIStackView!
    
    // MARK: - IBOutlet - UILabels
    ///  Label for the affected car park name
    @IBOutlet weak var carPakNameLabel: UILabel!
    /// Label used to display car park postal address
    @IBOutlet weak var carParkAddress: UILabel!
    /// Global amount of car spot  (free and busy) within the affected car park
    @IBOutlet weak var carParkCapacityLabel: UILabel!
    /// Amount of free car spot available within the affected car park
    @IBOutlet weak var carParkFreeSpotLabel: UILabel!
    /// Arrary of UIImageView used to manage the asset available with the affected car park
    @IBOutlet var serviceAssets: [UIImageView]!
    /// Additional information provided from service related to the affected car park
    @IBOutlet weak var carParkInfoLabel: UILabel!
    
    // MARK: - IBAction
    ///  Performed when user select the "Annuler" button. This would dismiss the modal detailed view
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /// Performed when user select the "S'y rendre" button. This would use the openWithMap function to launch Apple Maps
    @IBAction func didTapGoButton(_ sender: Any) {
        openWithMap()
    }
    
    // MARK: - Functions - View Setup
    
    /// Used to setup the MKMapView (at the the top of the view) to display the affected car park on a map
    /// - Parameter carParkAnnotation: Affected annotation to display
    private func setUpMapView(_ carParkAnnotation: CarParkMapAnnotation?){
        guard let carParkAnnotation = carParkAnnotation else { return }
        mapView.layer.cornerRadius = 10.0;
        let region = MKCoordinateRegion(center: carParkAnnotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(carParkAnnotation)
    }
    
    // MARK: - Functions - Label setup
    /// Set the label related to the car park name using the affected car park details
    /// - Parameter carPark: Details of the affected car park
    private func setCarParkName(_ carPark: OneCarParkStruct) {
        carPakNameLabel.text = carPark.name
    }
    
    /// Set the label related to the car park address using the affected car park details
    /// - Parameter carPark: Details of the affected car park
    private func setCarParkAddress(_ carPark: OneCarParkStruct) {
        carParkAddress.text = carPark.address
    }
    
    private func setCarParkAssetService(_ carPark: OneCarParkStruct) {
        // PMR asset
        serviceAssets[0].isHidden = !carPark.hasPmrAccess
        // Bicycle asset
        serviceAssets[1].isHidden = !carPark.hasBicycleSpots
        // Motorbike asset
        serviceAssets[2].isHidden = !carPark.hasMotorbikeSpots
        // Carpool asset
        serviceAssets[3].isHidden = !carPark.hasCarpoolSpots
        // Vallet asset
        serviceAssets[4].isHidden = !carPark.hasValletService
        // Ev charger asset
        serviceAssets[5].isHidden = !carPark.hasEvCharger
        
        let filtered = serviceAssets.filter { oneService in
            return oneService.isHidden == false
        }
        if filtered.isEmpty {
            carParkServicesSatck.isHidden = true
        }
    }
    
    
        /// Set the label related to the car park capacity using the affected car park details
    /// - Parameter carPark: Details of the affected car park
    private func setCarParkCapacity(_ carPark: OneCarParkStruct) {
        carParkCapacityLabel.text = "Capacité : \(carPark.capacity) places"
    }
    
    /// Set the label related to the car park free spot using the affected car park details.
    /// Based on the amount of spot available or car park status the label may be displayed using other different style
    /// - Parameter carPark: Details of the affected car park
    private func setCarParkFreeSpotAmount(_ carPark: OneCarParkStruct) {
        carParkInfoStackViewBottom.setCustomSpacing(30, after: carParkFreeSpotLabel)
        carParkFreeSpotLabel.text = carPark.freeSpotDescription
        guard !carPark.isFull, !carPark.isClosed else {
            carParkFreeSpotLabel.textColor = UIColor(named: "ratioRed")
            return
        }
        carParkFreeSpotLabel.text = "Places disponibles : \(carPark.freeSpot) places"
        carParkFreeSpotLabel.textColor = UIColor(named: "ratioText")
    }
    
    /// Set the label related to the car park free info from OD using the affected car park details.
    /// - Parameter carPark: Details of the affected car park
    private func setCarParkInfor(_ carPark: OneCarParkStruct) {
        carParkInfoLabel.text = carPark.infor
    }
    
    // MARK: - Functions - Others
    
    /// Load each part of the details view for the related car park
    private func loadDetails() {
        guard let carParkData = affectedCarpark?.carParkInfo else { return }
        setCarParkName(carParkData)
        setCarParkAddress(carParkData)
        setCarParkAssetService(carParkData)
        setCarParkCapacity(carParkData)
        setCarParkFreeSpotAmount(carParkData)
        setCarParkInfor(carParkData)
    }
    
    /// Used when user tap on "Go" button. This would open the built-in Maps app and attempt to display an itinerary using thr driving mode
    func openWithMap() {
        guard let affectedCarpark = affectedCarpark else { return }
        let placeMark = MKPlacemark(coordinate: affectedCarpark.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = affectedCarpark.title
        mapItem.pointOfInterestCategory = .parking
        let launchOption = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true] as [String : Any]
        mapItem.openInMaps(launchOptions: launchOption)
    }
    
    func sendEvent() {
        guard let carParkData = affectedCarpark?.carParkInfo else { return }
        Mixpanel.mainInstance().track(event: "carParkDetailsDisplayed", properties: [
            "affectedCarPark": carParkData.name,
        ])
    }
}
