//
//  FiltersSettingsViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 02/09/2022.
//

import UIKit

class FiltersSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        filtersSettingsNavigatonBar.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(dismissTheView))
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

    // MARK: - @IBOutlet
    @IBOutlet weak var filtersSettingsNavigatonBar: UINavigationItem!
    @IBOutlet weak var filtersOptionsUITableView: UITableView!
    
    // MARK: - Functions

    @objc private func dismissTheView(){
        //self.dismiss(animated: true)
        coreDataManager?.resetFilter()
        filtersOptionsUITableView.reloadData()
    }
    
    @objc private func didTapSaveFiltersSettings() {
        print("Filtre modifié")
        self.dismiss(animated: true)
    }
}

// MARK: - Extensions - UITableView

extension FiltersSettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.filtersList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "oneFilterBasicCell", for: indexPath) as? oneFilterTableViewCell,
              let coreDataManager = coreDataManager else {
            return UITableViewCell()
        }
        let index = indexPath.row
        let affectedFilter = coreDataManager.filtersList[index]
        cell.configure(for: affectedFilter.humanName ?? "Inconnu", filterValue: affectedFilter.currentOption?.humanName ?? "Aucune")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}


// MARK: - Extensions - Segue
extension FiltersSettingsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFilterListToFilterOptions" {
            guard let index = filtersOptionsUITableView.indexPathForSelectedRow?.row,
                  let oneFilterVC = segue.destination as? OneFilterOptionsListViewController,
                  let coreDataManager = coreDataManager else { return }
            oneFilterVC.affectedFiltre = coreDataManager.filtersList[index]
        }
    }
}
