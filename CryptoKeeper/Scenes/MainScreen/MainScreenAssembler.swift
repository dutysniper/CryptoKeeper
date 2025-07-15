//
//  MainScreenAssembler.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

final class MainScreenAssembler {
	func assembly() -> MainScreenViewController {
		let viewController = MainScreenViewController()
		let networkManager = NetworkManager()
		let presenter = MainScreenPresenter(viewController: viewController)
		let interactor = MainScreenInteractor(presenter: presenter, networkManager: networkManager)

		viewController.interactor = interactor

		return viewController
	}
}
