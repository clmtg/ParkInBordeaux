//
//  FiltersSettingsViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 02/09/2022.
//

import UIKit

/// View controller handling filters menu. This is not the view controller handling filter options selections
class FiltersSettingsViewController: UIViewController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersSettingsNavigatonBar.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFilterSelection))
        filtersSettingsNavigatonBar.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(didTapSaveFiltersSettings))
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataRepo(coreDataStack: coredataStack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filtersOptionsUITableView.reloadData()
    }
    
    // MARK: - Vars
    /// CoreData instance
    private var coreDataManager: CoreDataRepo?
    
    /// List of filter wich can be edited and apply on the map
    private var filtresList: [FiltersCD] {
        guard let coreDataManager = coreDataManager else { return [FiltersCD]() }
        let list = coreDataManager.filtersList
        return list.sorted(by: {$0.humanName! < $1.humanName!})
    }

    // MARK: - @IBOutlet
    @IBOutlet weak var filtersSettingsNavigatonBar: UINavigationItem!
    @IBOutlet weak var filtersOptionsUITableView: UITableView!
    
    // MARK: - Functions
    /// Performed when Reset button (within navagication view controller) is tapped. Remove all filter applied to the map
    @objc private func resetFilterSelection(){
        coreDataManager?.resetFilter()
        filtersOptionsUITableView.reloadData()
    }
    
    @objc private func didTapSaveFiltersSettings() {
        performSegue(withIdentifier: "segueFromFiltersListToMap", sender: self)
    }
}

// MARK: - Extensions - UITableViewDataSource

extension FiltersSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "oneFilterBasicCell", for: indexPath) as? oneFilterTableViewCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        let affectedFilter = filtresList[index]
        cell.configure(for: affectedFilter.humanName ?? "Inconnu", filterValue: affectedFilter.currentOption?.humanName ?? "")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - Extensions - Segue
extension FiltersSettingsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFilterListToFilterOptions" {
            guard let index = filtersOptionsUITableView.indexPathForSelectedRow?.row,
                  let oneFilterVC = segue.destination as? OneFilterOptionsListViewController else { return }
            oneFilterVC.affectedFiltre = filtresList[index]
        }
    }
}
