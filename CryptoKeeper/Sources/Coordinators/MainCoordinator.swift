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
				guard let topVC = self?.navigationController.topViewController as? LoginScreenViewController else { return }
				self?.showLoginErrorAlert(on: topVC, message: errorMessage)
			}
		)
		navigationController.pushViewController(viewController, animated: true)
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
		print("Push newVC")
		let viewController = MainScreenAssembler().assembly()
		 navigationController.setViewControllers([viewController], animated: true)
	}
}
