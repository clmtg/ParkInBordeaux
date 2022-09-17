//
//  FakeResponseData.swift
//  ParkInBordeauxTests
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation
@testable import ParkInBordeaux

final class FakeResponseData {
    
    // MARK: - URL
    static let openDataBordeauxEndpoint: URL = URL(string: "https://data.bordeaux-metropole.fr/geojson?key=5789BFKLPW&typename=st_park_p")!
    
    // MARK: - Responses
    static let validResponseCode = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let invalidResponseCode = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // MARK: - Data
    static var geocsonCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        return bundle.dataFromJson("correctGeojsonSample")
    }
    
    static var geocsonCorrectDataNoCarPark: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        return bundle.dataFromJson("NoFeatureGeojsonSample")
    }
        
    static let incorrectGeocsonData = "erreur".data(using: .utf8)!
}

// MARK: - Extensions related to Bundle
extension Bundle {
    
    /// Extract data from a json file
    /// - Parameter name: json file name
    /// - Returns: data
    func dataFromJson(_ name: String) -> Data {
        guard let mockURL = url(forResource: name, withExtension: "geojson"),
              let data = try? Data(contentsOf: mockURL) else {
            fatalError("Failed to load \(name) from bundle.")
        }
        return data
    }
}
