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
    private let session: URLSession
    
    // MARK: - initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Functions
    func getCarParksAvailabilityPins(completionHandler: @escaping (Result<[MKAnnotation],CarParksServiceError>) -> Void) {
        
        var carParksPinsData = [CarParkMapAnnotation]()

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
                completionHandler(.failure(.unexpectedResponse))
                return
            }
            geojsonfeatures.forEach { oneFeature in
                guard let geometry = oneFeature.geometry.first,
                      let propertiesFeature = oneFeature.properties else {
                    return
                }
                if let location = geometry as? MKAnnotation {
                    let geojsonProperties = try? JSONDecoder().decode(GeojsonProperties.self, from: propertiesFeature)
                    carParksPinsData.append(CarParkMapAnnotation(coordinate: location.coordinate, title: geojsonProperties?.nom, subtitle: nil, ident: geojsonProperties?.ident))
                }
            }
            completionHandler(.success(carParksPinsData))
        }.resume()
    }
}

