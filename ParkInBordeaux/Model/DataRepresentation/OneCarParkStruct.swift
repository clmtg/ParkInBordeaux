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
    
    /// Affected car park name
    var name: String {
        guard let data = properties?.nom else { return "Inconnu" }
        return data
    }
    
    /// Affected car park address
    var address: String {
        guard let data = properties?.adresse else { return "Adresse postale indisponible" }
        return data
    }
    
    /// Affected car park capacity (amount of car spots global)
    var capacity: Int {
        guard let data = properties?.npTotal else { return 0 }
        return data
    }
    
    /// Amount of free spot (not used by a vehicule) for the affected car park
    var freeSpot: Int {
        guard let data = properties?.libres else { return 0 }
        return data
    }
    
    /// Amount of the free spot (regardless if they are used or not) for the affected car park
    var freeSpotDisablePerson: Int {
        guard let data = properties?.npPmr else { return 0 }
        return data
    }
    
    /// Affected car park status (Open/closed/etc...)
    var status: String {
        guard let data = properties?.etat else { return "indisponible" }
        return data.capitalizingFirstLetter()
    }
    
    /// Affected car park managing company (also called exploitant)
    var manager: String {
        guard let data = properties?.exploit else { return "indisponible" }
        return data.capitalizingFirstLetter()
    }
    
    /// Additional info provided by the affected car park
    var infor: String {
        guard let data = properties?.infor else { return "Aucune information supplémentaire" }
        return data
    }
    
    /// Based on other properties, it does let us know if the car park is fulled (true) (no free spot) or not (false)
    var isFull: Bool {
        guard freeSpot > 0 else { return true }
        guard status != "Complet" else { return true }
        return false
    }
    
    /// Based on other properties, it does let us know if the car park is closed (true) or not (false)
    var isClosed: Bool {
        guard status != "Ferme" else { return true }
        return false
    }
    
    // MARK: - Vars - Related to car park service
    
    /// Does the affected car park can easily be used by disabled user
    var hasPmrAccess: Bool {
        guard freeSpotDisablePerson > 0 else { return false }
        return true
    }
    
    /// Does the affected car park has spots to park bycicle
    var hasBicycleSpots: Bool {
        guard let data = properties?.npVeltot, data > 0 else { return false }
        return true
    }
    
    /// Does the affected car park has spots to park motorbike
    var hasMotorbikeSpots: Bool {
        guard let data = properties?.np2rmot, data > 0 else { return false }
        return true
    }
    
    /// Does the affected car park has spots for car pooling user
    var hasCarpoolSpots: Bool {
        guard let data = properties?.npCovoit, data > 0 else { return false }
        return true
    }
    
    /// Can a vallet service be used within the affected car park
    var hasValletService: Bool {
        guard let data = properties?.npStlav, data > 0 else { return false }
        return true
    }
    
    /// Can eletric vehicule be charged within the affectee car park
    var hasEvCharger: Bool {
        guard let data = properties?.npVle, data > 0 else { return false }
        return true
    }
    
    /// Does provide an accurate description related to the amount of free spots available in real time or not
    var freeSpotDescription: String {
        var description = String()
        switch status {
        case "Ferme":
            description = "Fermé"
        case "Complet":
            description = status
        case "Ouvert":
            guard let properties = properties else { return "indisponible" }
            if status == "Ouvert", properties.libres == nil {
                description = "Nombre de places libres indisponibles"
            }
        default:
            description = "\(freeSpot) places disponibles"
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
