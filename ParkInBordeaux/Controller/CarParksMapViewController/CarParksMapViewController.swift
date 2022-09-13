//
//  CarParksMapViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import UIKit
import MapKit

/// View controller for the view displaying the MapsView with annotations for
final class CarParksMapViewController: UIViewController {
    
    // MARK: - LifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCarParksMapView()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataRepo(coreDataStack: coredataStack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCarParksDataSet()
    }
    
    // MARK: - Vars
    /// Model instance
    let carParkCore = CarParksCoreService()
    /// CoreData instance
    private var coreDataManager: CoreDataRepo?
    
    var amountOfCarPark = 0
    
    // MARK: - IBOutlet
    /// MKMapView controller used to display car maps on Maps
    @IBOutlet weak var carParksMapViewController: MKMapView!
    @IBOutlet weak var activityIndicatorViewController: UIView! {
        didSet {
            activityIndicatorViewController.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterMenuUIButton: UIButton!
    
    // MARK: - IBAction
    
    // MARK: - Functions
    
    /// Set the MKMapView which will be used within the view. (Region limit, zoom limit, initial location, etc ...)
    private func setCarParksMapView() {
        let cityCenterLocation = CLLocationCoordinate2D(latitude: 44.84203155780349, longitude: -0.5744705263091234)
        let regionCenter = MKCoordinateRegion(center: cityCenterLocation, latitudinalMeters: 7000, longitudinalMeters: 7000)
        let regionAccessible = MKCoordinateRegion(center: cityCenterLocation, latitudinalMeters: 25000, longitudinalMeters: 25000)
        carParksMapViewController.setRegion(regionCenter, animated: true)
        carParksMapViewController.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: regionAccessible), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 90000)
        carParksMapViewController.setCameraZoomRange(zoomRange, animated: true)
        setupCompassButton()
        registerAnnotationViewClasses()
    }
    
    /// Set the compass button within the MKMapView (carParksMapViewController). Compass is displayed only when Map isn't pointing North
    private func setupCompassButton() {
        let compass = MKCompassButton(mapView: carParksMapViewController)
        compass.compassVisibility = .visible
    }
    
    /// Register the classes generating customer MKAnnotationView. This is uses to reload MkAnnotation rather than generated new one
    func registerAnnotationViewClasses() {
        carParksMapViewController.register(CarParkMapAnnotationView.self, forAnnotationViewWithReuseIdentifier: CarParkMapAnnotationView.reuseID)
        carParksMapViewController.register(CarParksClusterAnnotationViewMaker.self, forAnnotationViewWithReuseIdentifier: CarParksClusterAnnotationViewMaker.reuseID)
    }
    
    /// Set the UIbutton filterMenuUIButton title based on the amount annotation being displayed
    func setFilterButtonTitle() {
        var titleFilterButton: String
        let amountOfAnnotation = amountOfCarPark
        switch amountOfAnnotation {
        case 0:
            titleFilterButton = "Aucun parking trouvé"
        case 1:
            titleFilterButton = "\(amountOfAnnotation) parking trouvé"
        default:
            titleFilterButton = "\(amountOfAnnotation) parkings trouvés"
        }
        filterMenuUIButton.setTitle(titleFilterButton, for: .normal)
    }
    
    func displayLoadingView(_ status: Bool) {
        self.activityIndicatorViewController.isHidden = !status
        self.carParksMapViewController.isUserInteractionEnabled = !status
    }
    
    /// Retreive the information related to the car parks provided by the model and load them up into the MapViewController
    func loadCarParksDataSet() {
        self.carParkCore.getLatestUpdate() { resultCarParkData in
            DispatchQueue.main.async { [self] in
                displayLoadingView(true)
                guard case .success(let carParksData) = resultCarParkData else {
                    if case .failure(let errorInfo) = resultCarParkData {
                        let resetAction = UIAlertAction(title: "Afficher tous les parking", style: .default) { alertAction in
                            guard let coreDataManager = self.coreDataManager else { return }
                            coreDataManager.resetFilter()
                            self.loadCarParksDataSet()
                        }
                        self.displayAnAlert(title: "Oups", message: errorInfo.description, actions: [resetAction])
                        self.displayLoadingView(false)
                    }
                    return
                }
                self.carParksMapViewController.removeAnnotations(carParksMapViewController.annotations)
                self.amountOfCarPark = carParksData.count
                carParksData.forEach { oneCarPark in
                    if let location = oneCarPark.location, let properties = oneCarPark.properties {
                        let affectedAnnotation = CarParkMapAnnotation(for: location ,
                                                                      title: properties.nom ?? "No name",
                                                                      subtitle: properties.etat ?? "Inconnu",
                                                                      carParkInfo: oneCarPark)
                        self.carParksMapViewController.addAnnotation(affectedAnnotation)
                    }
                }
                carParksMapViewController.fitAll()
                setFilterButtonTitle()
                displayLoadingView(false)
                
            }
        }
    }
}

// MARK: - Extensions - Maps - Delegate
extension CarParksMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let view: MKAnnotationView?
        if let mapAnnotation = annotation as? CarParkMapAnnotation {
            view = carParksMapViewController.dequeueReusableAnnotationView(withIdentifier: CarParkMapAnnotationView.reuseID, for: mapAnnotation)
        }
        else {
            view = carParksMapViewController.dequeueReusableAnnotationView(withIdentifier: CarParksClusterAnnotationViewMaker.reuseID, for: annotation)
        }
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotationView = view as? CarParkMapAnnotationView,
              let carParkAnnotation = annotationView.annotation as? CarParkMapAnnotation else {
            return
        }
        performSegue(withIdentifier: "segueFromMapToDetails", sender: carParkAnnotation)
    }
}


// MARK: - Extensions - Segue
extension CarParksMapViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromMapToDetails" {
            guard let carParkDetailsVC = segue.destination as? CarParkDetailsViewController,
                  let affectedAnnotation = sender as? CarParkMapAnnotation else {
                return
            }
            carParkDetailsVC.affectedCarpark = affectedAnnotation
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        loadCarParksDataSet()
    }
    
}
