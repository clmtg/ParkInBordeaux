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
        startUIButton.layer.cornerRadius = 6
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataRepo(coreDataStack: coredataStack)
    }
    
    // MARK: - Vars
    /// CoreData instance
    private var coreDataManager: CoreDataRepo?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var startUIButton: UIButton!
    
    // MARK: - @IBAction
    
    @IBAction func didTappedTutorialButtonComplet(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "firstTimeFlag")

        if let coreDataManager = coreDataManager {
            coreDataManager.generateDefaultFilterConfig()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let carParksViewController = storyboard.instantiateViewController(withIdentifier: "CarParksMapViewController") as! CarParksMapViewController
        guard var viewControllers = navigationController?.viewControllers else { return }
        _ = viewControllers.popLast()
        viewControllers.append(carParksViewController)
        navigationController?.setViewControllers(viewControllers, animated: true)
    }
}
