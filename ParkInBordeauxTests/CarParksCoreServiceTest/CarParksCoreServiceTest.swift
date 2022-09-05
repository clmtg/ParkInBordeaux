//
//  CarParksCoreServiceTest.swift
//  ParkInBordeauxTests
//
//  Created by Clément Garcia on 17/08/2022.
//

import XCTest
@testable import ParkInBordeaux

class CarParksCoreServiceTest: XCTestCase {
    
    // MARK: - Vars
    
    //Fake session confirguration set in order to preform unit tests
    private let sessionConfiguration: URLSessionConfiguration = {
        let sessionConfiguration=URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses=[URLProtocolFake.self]
        return sessionConfiguration
    }()
    
    // MARK: - Tests - Endpoint generation
    
    func testGivenEndpointIsNeeded_WhenEndpointRequested_ThenCorrectEndpointIsProvided() {
        let correctEndpoint = "https://data.bordeaux-metropole.fr/geojson?key=5789BFKLPW&typename=st_park_p"
        let sut = ApiEndpoint.getGlobalEndpoint()
        XCTAssertNotNil(sut)
        XCTAssertEqual(correctEndpoint, sut.description)
    }
    
    
    // FIXME: test is failing because encodage isn't always performed in the same order. Once "secteur" is first, another time "secteur" is second
    func testGivenApiQueryIsWithFilter_WhenEndpointRequested_ThenCorrectFilteredEndpointProvided() {
        let correctEndpoint = "https://data.bordeaux-metropole.fr/geojson?key=5789BFKLPW&typename=st_park_p&filter=%7B%22$and%22:%5B%7B%22secteur%22:%22CENTRE%22%7D,%7B%22exploit%22:%22KEOLIS%22%7D%5D%7D"
        let sut = ApiEndpoint.getEndpointWithFilter(["secteur": "CENTRE", "exploit": "KEOLIS"])
        XCTAssertNotNil(sut)
        XCTAssertEqual(correctEndpoint, sut.description)
    }
    
    // MARK: - Tests - CarParkCoreService - Initializer
    
    func testGivenCoreServiceIsNeeded_WhenCoreServiceIsRequested_ThenCoreIsProvided () {
        let sut = CarParksCoreService()
        XCTAssertNotNil(sut)
    }
    
    // MARK: - Tests - CarParkCoreService - Fonction getLatestUpdate
    
    func testGivenServiceUpDataCorrect_WhenLatestDataRequest_ThenDataProvidedAreOK() {
        // Setup part
        //Data provided are correct, the reponse code provided is valid (200) and there is no error (nil)
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geocsonCorrectData, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getLatestUpdate(with: nil) { result in
            guard case .success(let resultData) = result else {
                XCTFail(#function)
                return
            }
            // it would be great to check if resultData is of type CarParks (type alias!!)
            XCTAssertEqual(resultData.count, 92)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.05)
    }
    
    func testGivenServiceDownNoData_WhenRequestUpdate_ThenErrorIsThrown() {
        // Setup part
        //No data to provide, reponse code is invalid and error is still nill for now
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (nil, FakeResponseData.invalidResponseCode, CarParksServiceError.unexpectedResponse)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        
        sut.getLatestUpdate(with: nil) { result in
            guard case .failure(let resultData) = result else {
                XCTFail(#function)
                return
            }
            // it would be great to check if resultData is of type CarParks (type alias!!)
            XCTAssertEqual(resultData, .networkCallFailed)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.05)
    }
    
    func testGivenServiceIsUpButNoData_WhenRequestUpdate_ThenErrorIsThrown() {
        // Setup part
        //No data to provide, reponse code is invalid and error is still nill for now
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (nil, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getLatestUpdate(with: nil) { result in
            guard case .failure(let resultData) = result else {
                XCTFail(#function)
                return
            }
            // it would be great to check if resultData is of type CarParks (type alias!!)
            XCTAssertEqual(resultData, .networkCallFailed)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.05)
    }
    
    func testGivenServiceIsUpButDataAreIncorrectFormat_WhenRequestUpdate_ThenErrorIsThrown() {
        // Setup part
        //No data to provide, reponse code is invalid and error is still nill for now
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.incorrectGeocsonData, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getLatestUpdate(with: nil) { result in
            guard case .failure(let resultData) = result else {
                XCTFail(#function)
                return
            }
            // it would be great to check if resultData is of type CarParks (type alias!!)
            XCTAssertEqual(resultData, .networkCallFailed)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.05)
    }
    
    func testGivenServiceIsUpDataOKButNoCarParkLister_WhenRequestUpdate_ThenErrorIsThrown() {
        // Setup part
        //No data to provide, reponse code is invalid and error is still nill for now
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geocsonCorrectDataNoCarPark, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getLatestUpdate(with: nil) { result in
            guard case .failure(let resultData) = result else {
                XCTFail(#function)
                return
            }
            // it would be great to check if resultData is of type CarParks (type alias!!)
            XCTAssertEqual(resultData, .noCarParkWithinArea)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.05)
    }
}
