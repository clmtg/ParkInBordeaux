//
//  ApiEndpoint.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 17/08/2022.
//

import Foundation
import SwiftUI

/// Struct which defines endpoints for the OpenData Bordeaux api.
struct ApiEndpoint {

    // MARK: - Vars
    /// The endpoint to reach. (Part added after the api address. E.g.: myapi.com/path)
    var path: String
    /// ParamS to add within the endpoints
    var queryItems: [URLQueryItem] = []
    /// Full url endpoint
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "data.bordeaux-metropole.fr"
        components.path = "/" + path
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}

// MARK: - Extension
extension ApiEndpoint {
    /// Return the endpoint to reach in order to retreive the data for all the Bordeaux car park
    /// - Returns: Endpoint to reach
    static func getGlobalEndpoint() -> URL {
        let endpoint = ApiEndpoint(path: "geojson", queryItems: [
            .init(name: "key", value: ApiInfo.OpenDataBdx),
            .init(name: "typename", value: "st_park_p")
        ])
        return endpoint.url
    }
    
    /// Return the endpoint to reach in order to retreive the data where a filter has been applied (retrieved using CoreData)
    /// - Returns: URL to reach 
    static func getEndpointWithConfigFilter() -> URL? {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let coredataStack = appdelegate.coreDataStack
        let coreDataManager = CoreDataRepo(coreDataStack: coredataStack)
        var endpointFilters = EndpointFilters()
        coreDataManager.filtersList.forEach { oneFilter in
            if let currentOption = oneFilter.currentOption {
                endpointFilters.filters.append([oneFilter.systemName! : currentOption.systemName!])
            }
        }
        if endpointFilters.filters.count == 0 {
            return ApiEndpoint.getGlobalEndpoint()
        }
        guard let data = try? JSONEncoder().encode(endpointFilters),
              let dataString = String(data: data, encoding: .utf8) else {
            return ApiEndpoint.getGlobalEndpoint()
        }
        let endpoint = ApiEndpoint(path: "geojson", queryItems: [
            .init(name: "key", value: ApiInfo.OpenDataBdx),
            .init(name: "typename", value: "st_park_p"),
            .init(name: "filter", value: dataString)
        ])
        return endpoint.url
    }
}
