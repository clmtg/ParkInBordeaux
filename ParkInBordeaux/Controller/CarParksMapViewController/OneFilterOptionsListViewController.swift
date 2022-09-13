//
//  OneFilterOptionsListViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 07/09/2022.
//

import UIKit

/// View controller handling filter option selection
class OneFilterOptionsListViewController: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsUITableView.dataSource = self
        optionsUITableView.delegate = self
        loadViewControllerTitle()
        setupTableView()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataRepo(coreDataStack: coredataStack)
    }
    
    // MARK: - Vars
    /// The filter affected by the current edit
    var affectedFiltre: FiltersCD?
    
    /// The option available for the filter being edited
    var optionAvailable: [OptionsFilterCD] {
        guard let affectedFiltre = affectedFiltre, let optionsAvailable = affectedFiltre.optionsAvailable else {
            return [OptionsFilterCD]()
        }
        let unsortedOptions = optionsAvailable.allObjects as! [OptionsFilterCD]
        return unsortedOptions.sorted(by: { $0.humanName! < $1.humanName! })
    }
    
    /// CoreData instance
    private var coreDataManager: CoreDataRepo?
    
    // MARK: - IBOutlet
    /// Table view listing the filter options
    @IBOutlet weak var optionsUITableView: UITableView!
    
    // MARK: - Functions
    /// Set the view controller title based on the affected filter being edited
    private func loadViewControllerTitle() {
        guard let affectedFiltre = affectedFiltre else {
            self.title = "Inconnu"
            return
        }
        self.title = affectedFiltre.humanName
    }
    
    /// Set the table view listing the options for the filter being edited
    func setupTableView(){
        optionsUITableView.allowsMultipleSelection = false
    }
}

// MARK: - Extension - TableView - DataSource
extension OneFilterOptionsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let affectedFiltre = affectedFiltre,
                let optionsAvailable = affectedFiltre.optionsAvailable else {
            return 0
        }
        return optionsAvailable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = UITableViewCell(style: .default, reuseIdentifier: "oneOptionReuseID")
        cell.textLabel?.text = optionAvailable[index].humanName
        
        guard let affectedFiltre = affectedFiltre,
              let affectedFiltreOptionId = affectedFiltre.currentOption?.id,
              let cellOptionId = optionAvailable[index].id else { return  cell}
        
        if affectedFiltreOptionId == cellOptionId {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}

// MARK: - Extension - TableView - Delegate
extension OneFilterOptionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let affectedRow = tableView.cellForRow(at: indexPath) else { return }
        affectedRow.accessoryType = .checkmark
        let index = indexPath.row
        let selectedOptionCD = optionAvailable[index]
        guard let coreDataManager = coreDataManager,
              let affectedFiltre = affectedFiltre else { return }
        if affectedFiltre.currentOption?.id == selectedOptionCD.id {
            coreDataManager.editFilterCurrentOption(for: affectedFiltre, with: nil)
        }
        else {
            coreDataManager.editFilterCurrentOption(for: affectedFiltre, with: selectedOptionCD)
        }
        tableView.reloadData()
    }
}
