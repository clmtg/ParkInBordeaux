//
//  CarParksCoreService.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 17/08/2022.
//

import Foundation
import MapKit

/// Class used to gather and handle data related to car parks availability within Bordeaux city center
final class CarParksCoreService {
    
    // MARK: - Vars
    /// URLSession handling the call to the REST apis
    private let session: URLSession
    
    var carParksData = CarParks()

    // MARK: - initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Functions
    /// Perform the  network calls needed in order to retreive the update data set for all the car parks
    /// - Parameter completionHandler: Steps to perform if this is a success or a failure
    private func getCarParksAvailabilityFromGeojson(completionHandler: @escaping (Result<[MKGeoJSONFeature],CarParksServiceError>) -> Void) {
        session.dataTask(with: ApiEndpoint.getGlobalEndpoint()) { dataReceived, responseReceived, errorReceived in
            guard let data = dataReceived, errorReceived == nil else {
                completionHandler(.failure(.corruptData))
                return
            }
            guard let response = responseReceived as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.unexpectedResponse))
                return
            }
            guard let geojsonfeatures = try? MKGeoJSONDecoder().decode(data) as? [MKGeoJSONFeature] else {
                completionHandler(.failure(.undecodableGeojson))
                return
            }
            completionHandler(.success(geojsonfeatures))
        }.resume()
    }
    
    //=========================================================================================================
   
    
    func getLatestUpdate(completionHandler: @escaping (Result<[OneCarParkStruct],CarParksServiceError>) -> Void) {
        
        getCarParksAvailabilityFromGeojson { resultGeojsonFeatures in
            guard case .success(let geojsonFeaturesData) = resultGeojsonFeatures else {
                completionHandler(.failure(.networkCallFailed))
                return
            }
            geojsonFeaturesData.forEach { oneFeature in
                if let geometrey = oneFeature.geometry.first, let jsonProperties = oneFeature.properties {
                    if let properties = try? JSONDecoder().decode(GeojsonProperties.self, from: jsonProperties) {
                        
                        if let id = properties.ident {
                            self.carParksData.append(OneCarParkStruct(for: id, location:  geometrey.coordinate, properties: properties))
                        }
                    }
                }
            }
            
            if(self.carParksData.isEmpty) {
                completionHandler(.failure(.noCarParkWithinArea))
            } else {
                completionHandler(.success(self.carParksData))
            }
            
        }
        
    }
    
}
