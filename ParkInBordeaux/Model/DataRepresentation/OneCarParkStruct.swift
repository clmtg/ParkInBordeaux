//
//  OneCarParkStruct.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation
import MapKit

struct OneCarParkStruct {
    
    // MARK: - Vars
    
    /// Car park api system id
    var ident: String?
    
    // MARK: - Vars - Related to car park location

    /// The latitude and longitude associated with the car park
    var location: CLLocationCoordinate2D?
    /// Car park postal code
    var insee: String?
    /// Car park full postal address
    var adresse: String?
    /// Car park city area
    var secteur: String?
    /// Car park's type (in the ground, on the groud, etc...)
    var type: String?
    
    // MARK: - Vars - Car park owner's info
    /// Car park company user
    var exploit: String?
    /// Car park company contract owner
    var titul: String?
    /// Car park owner
    var propr: String?
    /// Car park handler (Délégation de service public pour Bordeaux Metropole, etc ...)
    var typgest: String?
    
    // MARK: - Vars - Car park prices
    /// Price for < 1/4hour
    var th_quar: Float?
    /// Price for < 1/2hour
    var th_demi: Float?
    /// Price for < 1hour
    var th_heur: Float?
    /// Price for < 2hours
    var th_2: Float?
    /// Price for < 3hours
    var th_3: Float?
    /// Price for < 4hours
    var th_4: Float?
    /// Price for < 10hours
    var th_10: Float?
    /// Price for < 24hours
    var th_24: Float?
    
    /// Price for one night
    var th_nuit: Float?
    
    /// Price for a one month membership
    var ta_resmoi: Float?
    /// Price for a one month bicycle membership
    var ta_moivel: Float?
    /// Price for a one month motorbike membership
    var ta_moimot: Float?
    /// Price for a 24/7 one month guest membership
    var ta_nres7j: Float?
    /// Price for user having a TBM membership
    var ta_titul: Float?
    /// Price for user having a one time TBM ticket
    var ta_ntitul: Float?
    /// Price for disabled user having a certification card.
    var ta_handi: Float?
    
    /// Price to park a car in thre street within the car park area
    var tv_1h: Float?
    
    // MARK: - Vars - Parking spots
    /// Amount of car spot for disabled person
    var np_pmr: Int?
    /// Amount of parking spots for bycicle
    var np_veltot: Int?
    /// Amount of parking spots for two wheels wehicule eletric engine
    var np_2rele: Int?
    /// Amount of parking spots for two wheels wehicule (not only eletric, all included)
    var np_2rmot: Int?
    
    /// Amount of parking spots for large vehidule (> 3.5T)
    var np_hgsup: Int?
    /// Amount of parking spots for large but NOT heavy vehidule (< 3.5T)
    var np_hginf: Int?
    /// Amount of spot for car wash company
    var np_stlav: Int?
    /// Amount of spot for car pooling
    var np_covoit: Int?
    /// Amount of spot for car pooling company (Autopartage/Autocool/Citiz)
    var np_mobalt: Int?
    
    /// Amount of spot for electric vehicule
    var np_vle: Int?
    /// Amount of spot for car impoud
    var np_fourr: Int?
    /// Amount of spot of temp park
    var np_pr: Int?
    /// Amount of potential global car spot (car park + temp park + impound park)
    var np_global: Int?
    /// Amount of car spot within car park or temp parks
    var np_total: Int?
    
    /// Amount of car spot available (real time info)
    var libres: Int?
    /// Amount of prepayed access (real time info)
    var prepaye: Int?
    /// Amount of car sports overall (real time info)
    var total: Int?
    
    /// Max large vehicule parking spot heigh
    var gabari_max: Float?
    /// Max standard vehicule parking spot heigh on all floor
    var gabari_std: Float?
    
    // MARK: - Vars - General info about car park
    /// Car park's name
    var nom: String?
    /// Car park's state (Open, Full, Membership required, Closed, etc...)
    var etat: String?
    /// General comment about the car park itself or prices or etc ...
    var infor: String?
    /// Car park type
    var ta_type: String?
    /// Amount of floors within car park
    var nb_niv: Int?
    /// Last time update of the car park data set
    //var mdate: Date?
    /// Car park URL website
    var url: String?
    /// Is car park connected to internet for real time data update
    var connecte: Int?
    /// Year the car park has been open
    var an_serv: String?
    /// Car park creation date
    //var cdate: Date?
}

