//
//  ApiEndpointTest.swift
//  ParkInBordeauxTests
//
//  Created by Clément Garcia on 16/09/2022.
//

import XCTest
@testable import ParkInBordeaux

class ApiEndpointTest: XCTestCase {
    
    // MARK: - Vars
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataRepo!
    
    //Fake session confirguration set in order to preform unit tests
    private let sessionConfiguration: URLSessionConfiguration = {
        let sessionConfiguration=URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses=[URLProtocolFake.self]
        return sessionConfiguration
    }()
    
    //MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataRepo(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    // MARK: - Tests - Endpoint generation
    
    func testGivenEndpointIsNeeded_WhenEndpointRequested_ThenCorrectEndpointIsProvided() {
        let correctEndpoint = "https://data.bordeaux-metropole.fr/geojson?key=5789BFKLPW&typename=st_park_p"
        let sut = ApiEndpoint.getGlobalEndpoint()
        XCTAssertNotNil(sut)
        XCTAssertEqual(correctEndpoint, sut.description)
    }
    
    func testFilterConfigIsCustom_WhenEndpointRequested_ThenCorrectEndpointIsProvided() {
        //Setting up test
        coreDataManager.generateDefaultFilterConfig()
        let affectedFilter = coreDataManager.filtersList[0]
        let optionToLink = OptionsFilterCD(context: coreDataStack.mainContext)
        optionToLink.id = UUID()
        optionToLink.humanName = "Filter option for endpoint"
        optionToLink.systemName = "optionFilterForEndpoint"
        _ = coreDataManager.editFilterCurrentOption(for: affectedFilter, with: optionToLink)
        // Performing test
        guard let sut = ApiEndpoint.getEndpointWithConfigFilter(coreDataManager) else {
            XCTFail("ApiEndpoint didn't manage to generated a proper URL")
            return
        }
        XCTAssertTrue(sut.description.contains(optionToLink.systemName!))        
    }
    
    
    
}
