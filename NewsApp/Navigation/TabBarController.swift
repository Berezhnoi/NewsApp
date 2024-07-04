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
        // Create your main view controller
        let mainViewController = MainViewController()
        mainViewController.title = "Main"
        mainViewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))

        // Create your favorites view controller
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.title = "Favorites"
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))

        // Embed them in navigation controllers if needed
        let navController1 = UINavigationController(rootViewController: mainViewController)
        let navController2 = UINavigationController(rootViewController: favoritesViewController)

        // Set the view controllers for the tab bar controller
        viewControllers = [navController1, navController2]
    }
}

