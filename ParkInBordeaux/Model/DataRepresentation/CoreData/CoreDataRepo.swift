//
//  CoreDataRepo.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 09/09/2022.
//

import Foundation
import CoreData

/// Class handling the data (get/save/delete/etc...) through the CoreDataStack
final class CoreDataRepo {
    
    // MARK: - Properties
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    // MARK: - Initializer
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    // MARK: - Computed var
    /// List of filters stored. This is an "easy way" to provide the filters config to the user.
    var filtersList: [FiltersCD] {
        let request: NSFetchRequest<FiltersCD> = FiltersCD.fetchRequest()
        guard let filters = try? managedObjectContext.fetch(request) else { return [] }
        return filters
    }
    
    //MARK: - Functions - EDIT (Add/Edit/Remove)
    
    /// Retrieve the base config for the car park filter. This config is located within the file DefaultFilterConfig.json
    /// - Returns: The filtre and their related options
    private func getDefaultFilterConfigFromJson() -> FiltersList? {
        let bundle = Bundle(for: CarParksCoreService.self)
        let filtersOptionsRawJson = bundle.dataFromJson("DefaultFilterConfig")
        guard let filterListData = try? JSONDecoder().decode(FiltersList.self, from: filtersOptionsRawJson) else { return nil }
        return filterListData
    }
    
    /// Does generate de default filters config based on "DefaultFilterConfig" file. This is usually used only onced within the "setup process"
    func generateDefaultFilterConfig() {
        guard let defaultFiltersList = getDefaultFilterConfigFromJson() else { return }
        defaultFiltersList.filters.forEach { oneFilter in
            addFilterToConfig(oneFilter.humanName, oneFilter.sysmName, oneFilter.options) { resultFilterAdded in
                return
            }
        }
    }
    
    /// Sotre a new filter using CoreData
    /// - Parameters:
    ///   - humanName: Readable new filter name
    ///   - systemName: Name used by the system of the affected new filter
    ///   - optionsFilter: Available option for the affected new filter
    ///   - completionHandler: Steps to perform once an attempt to store the new filter has been made.
    func addFilterToConfig(_ humanName: String,
                           _ systemName: String,
                           _ optionsFilter: [OptionsForOneFilter]?,
                           _ completionHandler: (Result<FiltersCD, CarParksServiceError>) -> Void) {
        
        let filter = FiltersCD(context: managedObjectContext)
        filter.humanName = humanName
        filter.systemName = systemName
        filter.id = UUID.init()
        
        guard coreDataStack.saveContext() == nil else {
            completionHandler(.failure(.localDataCorrupt))
            return
        }
        guard let optionsFilter = optionsFilter else {
            completionHandler(.success(filter))
            return
        }
        
        if linkOptionsToFilter(options: optionsFilter, affectedFilter: filter) {
            completionHandler(.success(filter))
        } else {
            completionHandler(.failure(.localDataCorrupt))
        }
    }
    
    /// Link list of options to a filter (e.g. Affected filter : "Car park type". Options list : "Free/Subscription Only/Hourly/etc..." )
    /// - Parameters:
    ///   - options: List of option to create and link to the affected filter
    ///   - affectedFilter: Target filter to link the options
    /// - Returns: true if no issue occured during link. Otherwise false
    func linkOptionsToFilter(options: [OptionsForOneFilter], affectedFilter: FiltersCD) -> Bool {
        var optionsToSave = [OptionsFilterCD]()
        options.forEach { oneOption in
            let data = OptionsFilterCD(context: managedObjectContext)
            data.id = UUID.init()
            data.systemName = oneOption.optionSystemName
            data.humanName = oneOption.optionHumanName
            data.affectedFilter = affectedFilter
            optionsToSave.append(data)
        }
        guard coreDataStack.saveContext() == nil else { return false }
        return true
    }
    
    /// Edit the option currently used by a specific filter
    /// - Parameters:
    ///   - filterFromMenu: Affected filter
    ///   - selectedOption: New option used by the affected filter
    func editFilterCurrentOption(for filterFromMenu: FiltersCD, with selectedOption: OptionsFilterCD?) {
        guard let idProvided = filterFromMenu.id,
              let affectedFilter = getFilterDetailWithID(idProvided) else { return }
        
        guard let selectedOptionId = selectedOption?.id,
              let affectedOption = getOptionDetailWithID(selectedOptionId) else {
            affectedFilter.currentOption = nil
            coreDataStack.saveContext()
            return
        }
        affectedFilter.currentOption = affectedOption
        coreDataStack.saveContext()
    }
    
    /// Remove currently used options for all the filters
    func resetFilter(){
        let filterRequest: NSFetchRequest<FiltersCD> = FiltersCD.fetchRequest()
        guard let dataFilter = try? coreDataStack.mainContext.fetch(filterRequest) else { return }
        dataFilter.forEach { oneFilter in
            oneFilter.currentOption = nil
        }
        coreDataStack.saveContext()
    }
    
    /// Retreive a specific filter using the related id
    /// - Parameter idLooked: filter id to look for
    /// - Returns: The filter found otherwise nil
    func getFilterDetailWithID(_ idLooked: UUID) -> FiltersCD? {
        let filterRequest: NSFetchRequest<FiltersCD> = FiltersCD.fetchRequest()
        let filterCDFilter = NSPredicate(format: "id == %@", idLooked as CVarArg)
        filterRequest.predicate = filterCDFilter
        guard let dataFilter = try? coreDataStack.mainContext.fetch(filterRequest), dataFilter.count == 1 else { return nil }
        return dataFilter.first
    }
    
    /// Retreive a specific option using the related id
    /// - Parameter idLooked: option id to look for
    /// - Returns: The option found otherwise nil
    func getOptionDetailWithID(_ idLooked: UUID) -> OptionsFilterCD? {
        let optionRequest: NSFetchRequest<OptionsFilterCD> = OptionsFilterCD.fetchRequest()
        let optionRequestFilter = NSPredicate(format: "id == %@", idLooked as CVarArg)
        optionRequest.predicate = optionRequestFilter
        guard let dataFilter = try? coreDataStack.mainContext.fetch(optionRequest), dataFilter.count == 1 else { return nil }
        return dataFilter.first
    }
}
