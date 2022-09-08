//
//  FiltersList.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 06/09/2022.
//

import Foundation

// MARK: - FiltersList
struct FiltersList: Decodable {
    let fitres: [Filtre]
}

// MARK: - Fitre
struct Filtre: Decodable {
    let sysmName, humanName: String
    let options: [Option]
}

// MARK: - Option
struct Option: Decodable {
    let optionSystemName, optionHumanName: String
}
