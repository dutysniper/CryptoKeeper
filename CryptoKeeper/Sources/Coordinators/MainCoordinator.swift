//
//  MainCoordinator.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

final class MainCoordinator: BaseCoordinator {

	// MARK: - Dependencies
	private let navigationController: UINavigationController

	// MARK: - Initialization
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods
	override func start() {
		showLoginScreen()
//		showMainScreen()
	}

	func showLoginScreen() {
		let viewController = LoginScreenAssembler().assembly(
			onSuccess: { [weak self] in
				self?.showMainScreen()
			},
			onFailure: { [weak self] errorMessage in
				guard let topVC = self?.navigationController.topViewController as? LoginScreenViewController else { return }
				self?.showLoginErrorAlert(on: topVC, message: errorMessage)
			}
		)
		navigationController.setViewControllers([viewController], animated: true)
	}

	private func showLoginErrorAlert(on viewController: LoginScreenViewController, message: String) {
		let alert = UIAlertController(
			title: "Ошибка",
			message: message,
			preferredStyle: .alert
		)

		alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
		})

		alert.addAction(UIAlertAction(title: "Отменить", style: .destructive) { _ in
			viewController.clearTextFields()
		})

		viewController.present(alert, animated: true)
	}

	func showMainScreen() {
		let tabBarController = UITabBarController()

		let firstEmptyScreen = UIViewController()
		let secondEmptyScreen = UIViewController()
		let thirdEmptyScreen = UIViewController()
		let fouthEmptyScreen = UIViewController()
		firstEmptyScreen.tabBarItem = UITabBarItem(
			title: "Market",
			image: UIImage(named: "Market"),
			selectedImage: UIImage(named: "Market")
		)
		secondEmptyScreen.tabBarItem = UITabBarItem(
			title: "Wallet",
			image: UIImage(named: "Wallet"),
			selectedImage: UIImage(named: "Wallet")
		)

		thirdEmptyScreen.tabBarItem = UITabBarItem(
			title: "Text",
			image: UIImage(named: "Text"),
			selectedImage: UIImage(named: "Text")
		)
		fouthEmptyScreen.tabBarItem = UITabBarItem(
			title: "Account",
			image: UIImage(named: "Account"),
			selectedImage: UIImage(named: "Account")
		)
		let mainViewController = MainScreenAssembler().assembly(onExit: showLoginScreen)
		mainViewController.tabBarItem = UITabBarItem(
			title: "Home",
			image: UIImage(named: "Home"),
			selectedImage: UIImage(named: "Home")
		)
		let controllers = [
			mainViewController,
			firstEmptyScreen,
			secondEmptyScreen,
			thirdEmptyScreen,
			fouthEmptyScreen
		]
		tabBarController.viewControllers = controllers
		tabBarController.selectedIndex = 0

		firstEmptyScreen.tabBarItem.isEnabled = false
		secondEmptyScreen.tabBarItem.isEnabled = false
		thirdEmptyScreen.tabBarItem.isEnabled = false
		fouthEmptyScreen.tabBarItem.isEnabled = false
		
		UITabBar.appearance().unselectedItemTintColor = .lightGray
		UITabBar.appearance().selectedItem?.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
		UITabBar.appearance().barTintColor = .white
		UITabBar.appearance().isTranslucent = false

		if #available(iOS 15.0, *) {
			let tabBarAppearance = UITabBarAppearance()
			tabBarAppearance.configureWithOpaqueBackground()
			tabBarAppearance.backgroundColor = .white

			tabBarAppearance.shadowColor = nil

			UITabBar.appearance().standardAppearance = tabBarAppearance
			UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
		}

		 navigationController.setViewControllers([tabBarController], animated: true)
	}
}
