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
        reloadDataOnMapViewBasedOnNewConfig()
    }
    
    // MARK: - Vars
    /// Model instance
    let carParkCore = CarParksCoreService()
    var annotationDisplayed = [MKAnnotation]()
    /// CoreData instance
    private var coreDataManager: CoreDataRepo?
    
    // MARK: - IBOutlet
    /// MKMapView controller used to display car maps on Maps
    @IBOutlet weak var carParksMapViewController: MKMapView!
    @IBOutlet weak var activityIndicatorViewController: UIView! {
        didSet {
            activityIndicatorViewController.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - IBAction

    @IBAction func didtapReload(_ sender: Any) {
        reloadDataOnMapViewBasedOnNewConfig()
    }
    
    // MARK: - Functions
    
    /// Set the MKMapView which will be used within the view. (Region limit, zoom limit, initial location, etc ...)
    private func setCarParksMapView() {
        let cityCenterLocation = CLLocationCoordinate2D(latitude: 44.84203155780349, longitude: -0.5744705263091234)
        let region = MKCoordinateRegion(center: cityCenterLocation, latitudinalMeters: 7000, longitudinalMeters: 7000)
        carParksMapViewController.setRegion(region, animated: true)
        carParksMapViewController.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 40000)
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
    
    /// Used to reload data within MapView following a refresh or a new config filter
    func reloadDataOnMapViewBasedOnNewConfig(){
        carParksMapViewController.removeAnnotations(annotationDisplayed)
        annotationDisplayed.removeAll()
        loadCarParksDataSet()
    }
    
    /// Retreive the information related to the car parks provided by the model and load them up into the MapViewController
    func loadCarParksDataSet() {
        self.carParkCore.getLatestUpdate() { resultCarParkData in
            DispatchQueue.main.async { [self] in
                self.displayLoadingView(true)
                guard case .success(let carParksData) = resultCarParkData else {
                    if case .failure(let errorInfo) = resultCarParkData {
                        let resetAction = UIAlertAction(title: "Afficher tous les parking", style: .default) { alertAction in
                            guard let coreDataManager = self.coreDataManager else { return }
                            coreDataManager.resetFilter()
                            self.reloadDataOnMapViewBasedOnNewConfig()
                        }
                        self.displayAnAlert(title: "Oups", message: errorInfo.description, actions: [resetAction])
                        self.displayLoadingView(false)
                    }
                    return
                }
                
                carParksData.forEach { oneCarPark in
                    if let location = oneCarPark.location, let properties = oneCarPark.properties {
                        let affectedAnnotation = CarParkMapAnnotation(for: location ,
                                                                      title: properties.nom ?? "No name",
                                                                      subtitle: properties.etat ?? "Inconnu",
                                                                      carParkInfo: oneCarPark)
                        self.annotationDisplayed.append(affectedAnnotation)
                        self.carParksMapViewController.addAnnotation(affectedAnnotation)
                    }
                }
                self.displayLoadingView(false)
            }
        }
    }
    
    func displayLoadingView(_ status: Bool) {
        self.activityIndicatorViewController.isHidden = !status
        self.carParksMapViewController.isUserInteractionEnabled = !status
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
}
