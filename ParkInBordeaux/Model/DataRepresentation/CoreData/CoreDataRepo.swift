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
    var filtersList: [FiltresCD] {
        let request: NSFetchRequest<FiltresCD> = FiltresCD.fetchRequest()
        guard let filtres = try? managedObjectContext.fetch(request) else { return [] }
        return filtres
    }
    
    //MARK: - Functions - EDIT (Add/Edit/Remove)
    
    /// Retrieve the base config for the car park filter. This config is located within the file DefaultFilterConfig.json
    /// - Returns: The filtre and theeir related options
    private func getDefaultFilterConfigFromJson() -> FiltersList? {
        let bundle = Bundle(for: CarParksCoreService.self)
        let filtersOptionsRawJson = bundle.dataFromJson("DefaultFilterConfig")
        guard let filterListData = try? JSONDecoder().decode(FiltersList.self, from: filtersOptionsRawJson) else { return nil }
        return filterListData
    }
    
    func generateDefaultFilterConfig() {
        guard let defaultFiltersList = getDefaultFilterConfigFromJson() else { return }
        defaultFiltersList.fitres.forEach { oneFiltre in
            addFilterToConfig(oneFiltre.humanName, oneFiltre.sysmName, oneFiltre.options) { resultFilterAdded in
                return
            }
        }
    }
    
    func addFilterToConfig(_ humanName: String,
                           _ systemName: String,
                           _ optionsFiltre: [OptionsForOneFilter]?,
                           _ completionHandler: (Result<FiltresCD, CarParksServiceError>) -> Void) {
        
        let filtre = FiltresCD(context: managedObjectContext)
        filtre.humanName = humanName
        filtre.systemName = systemName
        filtre.id = UUID.init()
        
        guard coreDataStack.saveContext() == nil else {
            completionHandler(.failure(.localDataCorrupt))
            return
        }
        guard let optionsFiltre = optionsFiltre else {
            completionHandler(.success(filtre))
            return
        }
        
        if linkOptionsToFiltre(options: optionsFiltre, affectedFiltre: filtre) {
            completionHandler(.success(filtre))
        } else {
            completionHandler(.failure(.localDataCorrupt))
        }
    }
    
    func linkOptionsToFiltre(options: [OptionsForOneFilter], affectedFiltre: FiltresCD) -> Bool {
        var optionsToSave = [OptionsFiltreCD]()
        options.forEach { oneOption in
            let data = OptionsFiltreCD(context: managedObjectContext)
            data.id = UUID.init()
            data.systemName = oneOption.optionSystemName
            data.humanName = oneOption.optionHumanName
            data.affectedFiltre = affectedFiltre
            optionsToSave.append(data)
        }
        guard coreDataStack.saveContext() == nil else { return false }
        return true
    }
    
    func editFiltreCurrentOption(for filtreFromMenu: FiltresCD, with selectedOption: OptionsFiltreCD?) {
        let filterRequest: NSFetchRequest<FiltresCD> = FiltresCD.fetchRequest()
        let filterCDFilter = NSPredicate(format: "id == %@", filtreFromMenu.id! as CVarArg)
        filterRequest.predicate = filterCDFilter
        guard let dataFilter = try? coreDataStack.mainContext.fetch(filterRequest), dataFilter.count == 1 else { return }
        guard let selectedOption = selectedOption else {
            dataFilter.first?.currentOption = nil
            coreDataStack.saveContext()
            return
        }
        let optionRequest: NSFetchRequest<OptionsFiltreCD> = OptionsFiltreCD.fetchRequest()
        let optionCDFilter = NSPredicate(format: "id == %@", selectedOption.id! as CVarArg)
        optionRequest.predicate = optionCDFilter
        guard let dataOption = try? coreDataStack.mainContext.fetch(optionRequest), dataOption.count == 1 else { return }
        dataFilter.first?.currentOption = dataOption.first
        coreDataStack.saveContext()
    }
    
    func resetFilter(){
        let filterRequest: NSFetchRequest<FiltresCD> = FiltresCD.fetchRequest()
        guard let dataFilter = try? coreDataStack.mainContext.fetch(filterRequest) else { return }
        dataFilter.forEach { oneFilter in
            oneFilter.currentOption = nil
        }
        coreDataStack.saveContext()
        
    }
    
    func getFilterDetailWithID(_ idLooked: UUID) -> FiltresCD? {
        let filterRequest: NSFetchRequest<FiltresCD> = FiltresCD.fetchRequest()
        let filterCDFilter = NSPredicate(format: "id == %@", idLooked as CVarArg)
        filterRequest.predicate = filterCDFilter
        guard let dataFilter = try? coreDataStack.mainContext.fetch(filterRequest), dataFilter.count == 1 else { return nil }
        return dataFilter.first
    }
}
