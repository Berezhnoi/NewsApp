//
//  TabBarController.swift
//  NewsApp
//
//  Created by rendi on 04.07.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        // Create the main view controller
        let mainViewController = MainViewController()
        mainViewController.title = "Main"
        mainViewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        // Create the favorites view controller
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.title = "Favorites"
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        // Create the categories view controller
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.title = "Categories"
        categoriesViewController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "square.grid.2x2"), selectedImage: UIImage(systemName: "square.grid.2x2.fill"))
        
        // Create the settings view controller
        let settingsViewController = UIViewController()
        settingsViewController.title = "Settings"
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))

        // Embed them in navigation controllers if needed
        let navController1 = UINavigationController(rootViewController: mainViewController)
        let navController2 = UINavigationController(rootViewController: favoritesViewController)
        let navController3 = UINavigationController(rootViewController: categoriesViewController)
        let navController4 = UINavigationController(rootViewController: settingsViewController)

        // Set the view controllers for the tab bar controller
        viewControllers = [navController1, navController2, navController3, navController4]
    }
}

