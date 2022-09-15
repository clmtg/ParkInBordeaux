//
//  OneCarParkStruct.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation
import MapKit

typealias CarParks = [OneCarParkStruct]

/// Does represente a car park.  (Location/capacity/available spots,etc ...)
struct OneCarParkStruct {
    // MARK: - Vars
    /// Car park id
    var id: String?
    /// The latitude and longitude associated with the car park
    var location: CLLocationCoordinate2D?
    /// Car park properties 
    var properties: GeojsonProperties?
    
    var name: String {
        guard let data = properties?.nom else { return "Inconnu" }
        return data
    }
    
    var address: String {
        guard let data = properties?.adresse else { return "Adresse postale indisponible" }
        return data
    }
    
    var capacity: Int {
        guard let data = properties?.npTotal else { return 0 }
        return data
    }
    
    var freeSpot: Int {
        guard let data = properties?.libres else { return 0 }
        return data
    }
    
    var freeSpotDisablePerson: Int {
        guard let data = properties?.npPmr else { return 0 }
        return data
    }
    
    var status: String {
        guard let data = properties?.etat else { return "indisponible" }
        return data.capitalizingFirstLetter()
    }
    
    var manager: String {
        guard let data = properties?.exploit else { return "indisponible" }
        return data.capitalizingFirstLetter()
    }
    
    var infor: String {
        guard let data = properties?.infor else { return "Aucune information supplémentaire" }
        return data
    }
    
    
    
    var isFull: Bool {
        guard freeSpot > 0 else { return true }
        guard status != "Complet" else { return true }
        return false
    }
    
    var isClosed: Bool {
        guard status != "Ferme" else { return true }
        return false
    }
    
    // MARK: - Vars - Related to car park service
    
    var hasPmrAccess: Bool {
        guard freeSpotDisablePerson > 0 else { return false }
        return true
    }
    
    var hasBicycleSpots: Bool {
        guard let data = properties?.npVeltot, data > 0 else { return false }
        return true
    }
    
    var hasMotorbikeSpots: Bool {
        guard let data = properties?.np2rmot, data > 0 else { return false }
        return true
    }
    
    var hasCarpoolSpots: Bool {
        guard let data = properties?.npCovoit, data > 0 else { return false }
        return true
    }
    
    var hasValletService: Bool {
        guard let data = properties?.npStlav, data > 0 else { return false }
        return true
    }
    
    var hasEvCharger: Bool {
        guard let data = properties?.npVle, data > 0 else { return false }
        return true
    }
 
    
    

    
    
    
    var freeSpotDescription: String {
        var description = String()
        switch status {
        case "Ferme":
            description = status
        case "Complet":
            description = status
        case "Ouvert":
            guard let properties = properties else { return "indisponible" }
            if status == "Ouvert", properties.libres == nil {
                description = "Nombre de places libre indisponible"
            }
        default:
            description = "\(freeSpot) places disponible"
        }
        return description
    }
   
    
    
    
    
    
    // MARK: - initializer
    init(for id: String?, location: CLLocationCoordinate2D?, properties: GeojsonProperties?) {
        self.id = id
        self.location = location
        self.properties = properties
    }
}
    


