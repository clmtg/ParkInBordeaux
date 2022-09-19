//
//  FakeDataCoreData.swift
//  ParkInBordeauxTests
//
//  Created by Clément Garcia on 16/09/2022.
//

import Foundation
@testable import ParkInBordeaux

struct FakeDataCoreData {
    
    // MARK: - Filters Options
    static let optionFilterStructA = OptionsForOneFilter(optionSystemName: "optionFilterStructA", optionHumanName: "Filter option A")
    
    static let optionFilterStructB = OptionsForOneFilter(optionSystemName: "optionFilterStructB", optionHumanName: "Filter option B")
    
    static let filterStructA = Filter(sysmName: "filterStructA", humanName: "Filter A", options: [optionFilterStructA, optionFilterStructB])
    
    static let filterStructB = Filter(sysmName: "filterStructB", humanName: "Filter B", options: [])
    
    let filtersListStruct = FiltersList(filters: [filterStructA, filterStructB])
    
    static var correctOptionFilterCDFirst: OptionsFilterCD {
         let data = OptionsFilterCD()
         data.id = UUID()
         data.systemName = "correctOptionFilterCDFirst"
         data.humanName = "First correct option for a FilterCD"
         data.affectedFilter = nil
         return data
     }
     
     static var correctOptionFilterCDSecond: OptionsFilterCD {
         let data = OptionsFilterCD()
         data.id = UUID()
         data.systemName = "correctOptionFilterCDSecond"
         data.humanName = "Second correct option for a FilterCD"
         data.affectedFilter = nil
         return data
     }
     
     static var correctFilterCDWithoutOptionSelected: FiltersCD {
         let data = FiltersCD()
         data.id = UUID()
         data.systemName = "correctFilterCDWithoutOption"
         data.humanName = "Correct FilterCD without option"
         data.currentOption = nil
         return data
     }
     
     static var correctFilterCDWithOption: FiltersCD {
         let data = FiltersCD()
         data.id = UUID()
         data.systemName = "correctFilterCDWithOption"
         data.humanName = "Correct FilterCD with selected option"
         data.currentOption = correctOptionFilterCDFirst
         return data
     }
     
     static var filterCDWithoutId: FiltersCD {
         let data = FiltersCD()
         data.id = nil
         data.systemName = "filterCDWithoutId"
         data.humanName = "Filter CD without ID"
         data.currentOption = nil
         return data
     }
}
