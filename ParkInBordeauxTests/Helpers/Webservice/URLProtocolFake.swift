//
//  URLProtocolFake.swift
//  ParkInBordeauxTests
//
//  Created by Clément Garcia on 19/08/2022.
//

import Foundation

final class URLProtocolFake: URLProtocol {
    
    static var fakeURLs = [URL?: (data: Data?, reponse: URLResponse?, error: Error?)]()
    
    override class func canInit(with request: URLRequest) -> Bool { return true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { return request }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    override func startLoading() {
        
        if let url = request.url {
            if let (data, reponse, _) = URLProtocolFake.fakeURLs[url] {
                if let responseStrong = reponse {
                    client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                if let dataStrong = data {
                    client?.urlProtocol(self, didLoad: dataStrong)
                }
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
