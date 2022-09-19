//
//  SetupPartTwoViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 26/08/2022.
//

import UIKit

/// Controller handling the second view of the one time setup display when the app is launch for the first time
class SetupPartTwoViewController: UIViewController {
    
    // MARK: - Life cycle
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
    /// Button "Start" displayed at the bottom of the view
    @IBOutlet weak var startUIButton: UIButton!
    
    // MARK: - @IBAction
    /// Used when the button "Start" displayed at the bottom of the view is tapped
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
