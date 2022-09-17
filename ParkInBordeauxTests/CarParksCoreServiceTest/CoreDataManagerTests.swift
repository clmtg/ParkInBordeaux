//
//  CoreDataManagerTests.swift
//  ParkInBordeauxTests
//
//  Created by Clément Garcia on 16/09/2022.
//

import XCTest
@testable import ParkInBordeaux

final class CoreDataManagerTests: XCTestCase {
    
    
    // MARK: - Properties
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataRepo!
    
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
    
    // MARK: - Tests - Related to adding Recipes
    
    func testGivenFilterConfigIsmissing_WhenGenerateDefaultFilterConfig_ThenConfigIsGenerated() {
        coreDataManager.generateDefaultFilterConfig()
        XCTAssertTrue(!coreDataManager.filtersList.isEmpty)
        XCTAssertTrue(coreDataManager.filtersList.count > 0)
        XCTAssertTrue(coreDataManager.filtersList[0].systemName == "type")
    }
    
    func testGivenFilterIsWithoutId_WhenAttemptToEdit_ThenFalseThown() {
        //Setting up test
        coreDataManager.generateDefaultFilterConfig()
        let affectedFilterCD = coreDataManager.filtersList[0]
        affectedFilterCD.id = nil
        XCTAssertTrue(affectedFilterCD.id == nil)
        // Performing test
        let sutResult = coreDataManager.editFilterCurrentOption(for: affectedFilterCD, with: nil)
        XCTAssertTrue(sutResult == false)
    }
    
    func testGivenNoOptionFilterProvided_WhenAttemptToLink_ThenTrueThown() {
        //Setting up test
        coreDataManager.generateDefaultFilterConfig()
        let affectedFilter = coreDataManager.filtersList[0]
        XCTAssertTrue(affectedFilter.currentOption == nil)
        let optionToLink = OptionsFilterCD(context: coreDataStack.mainContext)
        optionToLink.id = UUID()
        affectedFilter.currentOption = optionToLink
        XCTAssertTrue(affectedFilter.currentOption != nil)
        XCTAssertTrue(affectedFilter.currentOption == optionToLink)
        // Performing test
        _ = coreDataManager.editFilterCurrentOption(for: affectedFilter, with: nil)
        XCTAssertTrue(affectedFilter.currentOption == nil)
    }
    
    func testGivenOptionFilterIsWithoutId_WhenAttemptToLink_ThenFalseThown() {
        //Setting up test
        coreDataManager.generateDefaultFilterConfig()
        let affectedFilter = coreDataManager.filtersList[0]
        XCTAssertTrue(affectedFilter.currentOption == nil)
        let optionToLink = OptionsFilterCD(context: coreDataStack.mainContext)
        optionToLink.id = nil
        // Performing test
        _ = coreDataManager.editFilterCurrentOption(for: affectedFilter, with: optionToLink)
        XCTAssertTrue(affectedFilter.currentOption == nil)
    }
    
    func testGivenFilterAndOptionCorrect_WhenAttemptToLink_ThenEditIsDene() {
        //Setting up test
        coreDataManager.generateDefaultFilterConfig()
        let affectedFilter = coreDataManager.filtersList[0]
        XCTAssertTrue(affectedFilter.currentOption == nil)
        let optionToLink = OptionsFilterCD(context: coreDataStack.mainContext)
        optionToLink.id = UUID()
        // Performing test
        let sutResult = coreDataManager.editFilterCurrentOption(for: affectedFilter, with: optionToLink)
        XCTAssertTrue(affectedFilter.currentOption == optionToLink)
        XCTAssertTrue(affectedFilter.currentOption != nil)
        XCTAssertTrue(sutResult)
    }
    
    func testGivenConfigISCustom_WhenResetFilter_ThenConfigIsDefault() {
        //Setting up test
        coreDataManager.generateDefaultFilterConfig()
        let affectedFilters = [coreDataManager.filtersList[0], coreDataManager.filtersList[1]]
        let optionToLink = OptionsFilterCD(context: coreDataStack.mainContext)
        optionToLink.id = UUID()
        affectedFilters.forEach { oneFilter in
            XCTAssertTrue(oneFilter.currentOption == nil)
            coreDataManager.editFilterCurrentOption(for: oneFilter, with: optionToLink)
            XCTAssertTrue(oneFilter.currentOption == optionToLink)
        }
        // Performing test
        coreDataManager.resetFilter()
        affectedFilters.forEach { oneFilter in
            XCTAssertTrue(oneFilter.currentOption == nil)
        }
    }
}
