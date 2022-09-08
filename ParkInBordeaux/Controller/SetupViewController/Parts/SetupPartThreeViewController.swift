//
//  SetupPartThreeViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 26/08/2022.
//

import UIKit

class SetupPartThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Vars
    
    
    // MARK: - Functions
    
    @IBAction func didTappedTutorialButtonComplet(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "firstTimeFlag")
        ApiEndpoint.generateCarparkFiltersDefaultSettings()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let carParksViewController = storyboard.instantiateViewController(withIdentifier: "CarParksMapViewController") as! CarParksMapViewController
        guard var viewControllers = navigationController?.viewControllers else { return }
        _ = viewControllers.popLast()
        viewControllers.append(carParksViewController)
       navigationController?.setViewControllers(viewControllers, animated: true)
    }
}
