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
    
    var carParksAnnotationData = [CarParkMapAnnotation]()
    
    var carParksAnnotationAmount: Int {
        return carParksAnnotationData.count
        }
    
    // MARK: - initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Functions
    /// Perform the rest call needed in order to retreive the update data set for all the car parks
    /// - Parameter completionHandler: Steps to perform if this is a success or a failure
    func getCarParksAvailabilityFeatures(completionHandler: @escaping (Result<[MKGeoJSONFeature],CarParksServiceError>) -> Void) {
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
                completionHandler(.failure(.undecodableJson))
                return
            }
            completionHandler(.success(geojsonfeatures))
        }.resume()
    }
    
    /// Gather latest data related to car park availability then create CarParkMapAnnotation to be provided to the controller.
    /// - Parameter completionHandler: Should provide an array of CarParkMapAnnotation. However in a failure case a CarParksServiceError object would be used within the completionHandler
    func getCarParksAvailabilityAnnotation(completionHandler: @escaping (Result<[CarParkMapAnnotation],CarParksServiceError>) -> Void) {
        self.getCarParksAvailabilityFeatures { resultFeatures in
            guard case .success(let geojsonFeature) = resultFeatures else {
                completionHandler(.failure(.corruptData))
                return
            }
            geojsonFeature.forEach { oneFeature in
                if let geometry = oneFeature.geometry.first, let propertiesFeature = oneFeature.properties {
                    if let geojsonProperties = try? JSONDecoder().decode(GeojsonProperties.self, from: propertiesFeature) {
                        self.carParksAnnotationData.append(CarParkMapAnnotation(coordinate: geometry.coordinate,
                                                                                title: geojsonProperties.nom,
                                                                                subtitle: "soutitre",
                                                                                state: geojsonProperties.etat))
                        }
                }
            }
            if self.carParksAnnotationAmount == 0 {
                completionHandler(.failure(.noCarParkWithinArea))
            }
            else {
                completionHandler(.success(self.carParksAnnotationData))
            }
        }
    }
}
