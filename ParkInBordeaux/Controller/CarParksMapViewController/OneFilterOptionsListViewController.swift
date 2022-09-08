//
//  OneFilterOptionsListViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 07/09/2022.
//

import UIKit

class OneFilterOptionsListViewController: UIViewController {
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        optionsUITableView.dataSource = self
        optionsUITableView.delegate = self
        loadFilterOption()
    }
    
    // MARK: - Vars
    var affectedFiltre: Filtre?
    
    // MARK: - IBOutlet
    @IBOutlet weak var optionsUITableView: UITableView!
    
    // MARK: - Functions
    
    private func loadFilterOption() {
        guard let affectedFiltre = affectedFiltre else {
            self.title = "Inconnu"
            return
        }
        self.title = affectedFiltre.humanName
    }
}

// MARK: - Extension - TableView - DataSource

extension OneFilterOptionsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let affectedFiltre = affectedFiltre else {
            return 0
        }
        return affectedFiltre.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = UITableViewCell(style: .default, reuseIdentifier: "oneOptionReuseID")
        cell.textLabel?.text = affectedFiltre?.options[index].optionHumanName
        return cell
    }
}

// MARK: - Extension - TableView - Delegate

extension OneFilterOptionsListViewController: UITableViewDelegate {
   // tableView(_:accessoryButtonTappedForRowWith:)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let affectedRow = tableView.cellForRow(at: indexPath) else { return }
        affectedRow.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let affectedRow = tableView.cellForRow(at: indexPath) else { return }
        affectedRow.accessoryType = .none
    }
}
