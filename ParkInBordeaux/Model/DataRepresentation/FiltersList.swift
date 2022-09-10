//
//  FiltersList.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 06/09/2022.
//

import Foundation

// This is used to create the default database or filter related to the app.
// The raw config is located within the file DefaultFilterConfig.json



// MARK: - FiltersList
struct FiltersList: Decodable {
    let fitres: [Filtre]
}

// MARK: - Fitre
struct Filtre: Decodable {
    let sysmName, humanName: String
    let options: [OptionsForOneFilter]
}

// MARK: - Option
struct OptionsForOneFilter: Decodable {
    let optionSystemName, optionHumanName: String
}
