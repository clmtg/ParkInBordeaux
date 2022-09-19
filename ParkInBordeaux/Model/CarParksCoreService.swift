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
    
    /// Array of  OneCarParkStruct
    var carParksData = CarParks()

    // MARK: - initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Functions
    /// Perform the  network calls needed in order to retreive the update data set for all the car parks
    /// - Parameter completionHandler: Steps to perform if this is a success or a failure
    /// - Parameter endpoint: The endpoint to reach in order to retreive the geojson.
    /// This URL may differs based on filters applied
    private func getCarParksAvailabilityFromGeojson(with endpoint: URL, completionHandler: @escaping (Result<[MKGeoJSONFeature],CarParksServiceError>) -> Void) {
        session.dataTask(with: endpoint) { dataReceived, responseReceived, errorReceived in
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
    
    /// Retreive car park occupency using OpenData Bordeaux api then parse the data to perform a closure
    /// - Parameter completionHandler: closure which would pass a CarParks var  ( = [OneCarParkStruct]) for success of a CarParksServiceError for failure
    func getLatestUpdate(_ completionHandler: @escaping (Result<[OneCarParkStruct],CarParksServiceError>) -> Void) {
        self.carParksData.removeAll()
        var endpoindToUse = ApiEndpoint.getGlobalEndpoint()
        if let endpoind = ApiEndpoint.getEndpointWithConfigFilter(nil) {
            endpoindToUse = endpoind
        }
        getCarParksAvailabilityFromGeojson(with: endpoindToUse) { resultGeojsonFeatures in
            guard case .success(let geojsonFeaturesData) = resultGeojsonFeatures else {
                completionHandler(.failure(.networkCallFailed))
                return
            }
            geojsonFeaturesData.forEach { oneFeature in
                if let geometrey = oneFeature.geometry.first, let jsonProperties = oneFeature.properties {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let properties = try? decoder.decode(GeojsonProperties.self, from: jsonProperties) {
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
