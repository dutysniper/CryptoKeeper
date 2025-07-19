//
//  AppCoordinator.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let window: UIWindow?

	// MARK: - Initialization

	init(window: UIWindow?) {
		self.navigationController = UINavigationController()

		self.window = window
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
	}

	// MARK: - Internal methods

	override func start() {
		runMainFLow()
	}

	func runMainFLow() {
		let coordinator = MainCoordinator(navigationController: navigationController)
		navigationController.setNavigationBarHidden(true, animated: false)
		addDependency(coordinator)
		coordinator.start()
	}
}
