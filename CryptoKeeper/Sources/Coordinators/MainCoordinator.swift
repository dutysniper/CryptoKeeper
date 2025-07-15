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
	}

	func showLoginScreen() {
		let viewController = LoginScreenAssembler().assembly(
			onSuccess: { [weak self] in
				self?.showMainScreen()
			},
			onFailure: { [weak self] errorMessage in
				self?.showLoginErrorAlert(message: errorMessage)
			}
		)
		navigationController.pushViewController(viewController, animated: true)
	}

	func showMainScreen() {
		print("Push newVC")
//		navigationController.pushViewController(MainScreenViewContoller, animated: true)
	}

	private func showLoginErrorAlert(message: String) {
		let alert = UIAlertController(
			title: "Ошибка",
			message: message,
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		navigationController.present(alert, animated: true)
	}
}
