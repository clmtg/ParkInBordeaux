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
    
    // MARK: - Tests - Endpoint generation
    
 
    
    // MARK: - Tests - CarParkCoreService
    
    func testGivenDataAvailabilityIsNeeded_WhenCoreServiceIsRequested_ThenModelObjectIsProvided() {
        let carParkCore = CarParksCoreService()
        print("================================")
        print("Before function call")
        
        carParkCore.getCarParksAvailability { resultClosure in
            print(resultClosure)
        }

        print("After function call")
        print("================================")
        
    }
}
