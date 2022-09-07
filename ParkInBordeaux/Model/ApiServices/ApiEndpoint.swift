//
//  ApiEndpoint.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 17/08/2022.
//

import Foundation

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
    
    
    static func getEndpointWithFilter(_ filters: [String: String]?) -> URL {
        
        // Checking if filters have been provided and then generated related JSON based on struct EndpointFilters
        guard let filtersData = filters else {
            return ApiEndpoint.getGlobalEndpoint()
        }
        
        var endpointFilters = EndpointFilters()
        filtersData.forEach { oneFilter in
            endpointFilters.filters.append([oneFilter.key : oneFilter.value])
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
    
    static func getFiltersOptions() -> FiltersList? {
        let bundle = Bundle(for: CarParksCoreService.self)
        let filtersOptionsRawJson = bundle.dataFromJson("FiltersListData")
        
        guard let filterListData = try? JSONDecoder().decode(FiltersList.self, from: filtersOptionsRawJson) else {
            return nil
        }
        return filterListData
    }
}




