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
        filtersSettingsNavigatonBar.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: #selector(dismissTheView))
        filtersSettingsNavigatonBar.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(didTapSaveFiltersSettings))
        filtersOptionsUITableView.dataSource = self
        
        if let filtersOptionData = ApiEndpoint.getFiltersOptions() {
            filtersOptionList.append(contentsOf: filtersOptionData.fitres)
        }
    }
    
    // MARK: - Vars
    
    private var filtersOptionList = [Filtre]()

    // MARK: - @IBOutlet
    @IBOutlet weak var filtersSettingsNavigatonBar: UINavigationItem!
    @IBOutlet weak var filtersOptionsUITableView: UITableView!
    
    // MARK: - @IBActions
    
    // MARK: - Functions
    
    @objc private func dismissTheView(){
        self.dismiss(animated: true)
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
        return filtersOptionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "oneFilterBasicCell", for: indexPath) as? oneFilterTableViewCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        let affectedFilter = filtersOptionList[index]
        cell.configure(for: affectedFilter.humanName, filterValue: affectedFilter.options[0].optionHumanName)
        return cell
    }
}
