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
    }
    
    
    // MARK: - test
    var affectedCarpark: CarParkMapAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func openMapButton(_ sender: Any) {
        let placeMark = MKPlacemark(coordinate: affectedCarpark!.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        
        mapItem.name = affectedCarpark?.carParkInfo?.properties?.nom ?? "name"
        mapItem.pointOfInterestCategory = .parking
        
        mapItem.openInMaps()
    }
    
    @IBOutlet weak var carPakNameLabel: UILabel!
    func loadDetails() {
        
        
        
        
        
        mapView.layer.cornerRadius = 10.0;
        carPakNameLabel.text = affectedCarpark?.carParkInfo?.properties?.nom ?? "name"
        print(affectedCarpark?.carParkInfo?.properties?.nom ?? "name")
    }
    

}
