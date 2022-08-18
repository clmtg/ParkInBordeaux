//
//  CarParksServiceError.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 18/08/2022.
//

import Foundation

//Enumeration which list the error case for the services used within the Baluchon app
enum CarParksServiceError: Error {
    case corruptData
    case unexpectedResponse
}
