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
    
    // MARK: - Tests - CarParkCoreService
    
    func testGivenCoreServiceIsNeeded_WhenCoreServiceIsRequested_ThenCoreIsProvided () {
        let sut = CarParksCoreService()
        XCTAssertNotNil(sut)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    //Context -- Correct geoJson, Correct Answer (200), No error
    
    func testGivenServiceIsAvailable_WhenMKGeoJSONFeatureRequested_ThenCorrectGeoJsonProvided () {
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geocsonCorrectData, FakeResponseData.validResponseCode, nil)]
        
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityFeatures { resultFeature in
            guard case .success(let geoJsonData) = resultFeature else {
                XCTFail(#function)
                return
            }
            //Code to check
            XCTAssertEqual(geoJsonData.count, 92)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    //Context -- Data is nil, Correct Answer (200), No error
    // SEBASTIEN CHECK REQUIRED : Even if Nil is provided as Data the model provided Data instead of nill
    
    func testGivenServiceProvideNoData_WhenMKGeoJSONFeatureRequested_ThenErrorIsThrown() {
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (nil, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityFeatures { resultFeature in
            guard case .failure(let errorData) = resultFeature else {
                XCTFail(#function)
                return
            }
            XCTAssertEqual(errorData, .corruptData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    //Context -- Data is correct, Correct Answer (200), ERROR provided
    // SEBASTIEN CHECK REQUIRED : Even if an ERROR is provided, the model ignore the ERROR
    
    func testGivenServiceProvideAnError_WhenMKGeoJSONFeatureRequested_ThenErrorIsThrown() {
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geocsonCorrectData, FakeResponseData.validResponseCode, CarParksServiceError.unexpectedResponse)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityFeatures { resultFeature in
            guard case .failure(let errorData) = resultFeature else {
                XCTFail(#function)
                return
            }
            XCTAssertEqual(errorData, .corruptData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    //Context -- Data is correct, Incorrect status code, no error provided
    
    func testGivenServiceProvideWrongStatusCode_WhenMKGeoJSONFeatureRequested_ThenErrorISThrown () {
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geocsonCorrectData, FakeResponseData.invalidResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityFeatures { resultFeature in
            guard case .failure(let errorData) = resultFeature else {
                XCTFail(#function)
                return
            }
            XCTAssertEqual(errorData, .unexpectedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    //Context -- Data is incorrect (undecodable), status code 200, no error provided
    
    func testGivenServiceDataAreUndecodable_WhenMKGeoJSONFeatureRequested_ThenErrorISThrown () {
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.incorrectGeocsonData, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityFeatures { resultFeature in
            guard case .failure(let errorData) = resultFeature else {
                XCTFail(#function)
                return
            }
            XCTAssertEqual(errorData, .undecodableJson)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    func testGivenMKGeoJSONFeatureHasIssue_WhenAttemptToGetAnnotation_ThenErrorIsThrown(){
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.incorrectGeocsonData, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityAnnotation { resultAnnotations in
            guard case .failure(let errorData) = resultAnnotations else {
                XCTFail(#function)
                return
            }
            XCTAssertEqual(errorData, .corruptData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    func testGivenMKGeoJSONFeatureHasNoFeature_WhenAttemptToGetAnnotation_ThenErrorIsThrown(){
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geocsonCorrectDataNoCarPark, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityAnnotation { resultAnnotations in
            guard case .failure(let errorData) = resultAnnotations else {
                XCTFail(#function)
                return
            }
            XCTAssertEqual(errorData, .noCarParkWithinArea)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    //------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------
    
    func testGivenMKGeoJSONFeatureIsValid_WhenAttemptToGetAnnotation_CorrectAnnotationAreProvided(){
        URLProtocolFake.fakeURLs = [FakeResponseData.openDataBordeauxEndpoint: (FakeResponseData.geocsonCorrectData, FakeResponseData.validResponseCode, nil)]
        let fakeSession = URLSession(configuration: sessionConfiguration)
        let sut = CarParksCoreService(session: fakeSession)
        let expectation = XCTestExpectation(description: "Waiting...")
        
        sut.getCarParksAvailabilityAnnotation { resultAnnotations in
            guard case .success(let annotationsData) = resultAnnotations else {
                XCTFail(#function)
                return
            }
            XCTAssertEqual(annotationsData.count, 92)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    
    
    
}
