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
    
    // MARK: - Tests - CarParkCoreService - Initializer
    
    func testGivenCoreServiceIsNeeded_WhenCoreServiceIsRequested_ThenCoreIsProvided () {
        let sut = CarParksCoreService()
        XCTAssertNotNil(sut)
    }
    
    // MARK: - Tests - CarParkCoreService - Fonction getLatestUpdate
    
    func testGivenServiceUpDataCorrect_WhenLatestDataRequest_ThenDataProvidedAreOK() {
        // Setup part
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geojsonCorrectData, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        // Performing test
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getLatestUpdate() { result in
            guard case .success(let resultData) = result else {
                XCTFail(#function)
                return
            }
            // it would be great to check if resultData is of type CarParks (type alias!!)
            XCTAssertEqual(resultData.count, 92)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenNoParkListedInData_WhenLatestDataRequest_ThenErrorIsThrown() {
        // Setup part
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geojsonCorrectDataNoCarPark, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        // Performing test
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getLatestUpdate() { result in
            guard case .failure(let errorReturned) = result else {
                XCTFail(#function)
                return
            }
            XCTAssertTrue(errorReturned == CarParksServiceError.noCarParkWithinArea)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenServiceUpDataIncorrect_WhenLatestDataRequest_ThenErrorIsThrown() {
        // Setup part
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.incorrectGeojsonData, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        // Performing test
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getLatestUpdate() { result in
            guard case .failure(let errorReturned) = result else {
                XCTFail(#function)
                return
            }
            XCTAssertTrue(errorReturned == CarParksServiceError.networkCallFailed)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenServiceProvideAnError_WhenLatestDataRequest_ThenErrorIsThrown() {
        // Setup part
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geojsonCorrectData, FakeResponseData.invalidResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        // Performing test
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        sut.getLatestUpdate() { result in
            guard case .failure(let errorReturned) = result else {
                XCTFail(#function)
                return
            }
            XCTAssertTrue(errorReturned == CarParksServiceError.networkCallFailed)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
}
