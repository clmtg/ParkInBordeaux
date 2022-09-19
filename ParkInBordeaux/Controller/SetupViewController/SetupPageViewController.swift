//
//  SetupPageViewController.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 26/08/2022.
//

import UIKit

/// View controller for the view displaying the one time "tutorial" view control one first launch
class SetupPageViewController: UIPageViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagesViewController()
        setupPagesController()
    }
    
    // MARK: - Vars
    /// Array listing the UIViewControllers part of the one time setup views
    var pages = [UIViewController]()
    /// Line of dots to manage Page View controller
    let pageControl = UIPageControl()
    
    // MARK: - Functions
    /// Use to setup the UIPageViewController for the one time setup views
    func setupPagesViewController(){
        delegate = self
        dataSource = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        pages.append(storyboard.instantiateViewController(withIdentifier: "SetupPartOneViewController"))
        pages.append(storyboard.instantiateViewController(withIdentifier: "SetupPartTwoViewController"))
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    /// Used to set the UIPageControl (small dot at the bottom of the display) the one time setup views
    func setupPagesController() {
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor(named: "ratioRed")
        pageControl.pageIndicatorTintColor = UIColor(named: "lightPink")
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        view.addSubview(pageControl)
        let margins = view.layoutMarginsGuide
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            guide.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 0.0)
        ])
    }
    
    /// Used when the user taps on one dot  (small dot at the bottom of the display) to target a specific page
    /// - Parameter sender: the affected UIPageControl used by the user
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - Extension - UIPageViewControllerDelegate
extension SetupPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}

// MARK: - Extension - UIPageViewControllerDataSource
extension SetupPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return nil               // wrap to last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return nil
        }
    }
    
}
