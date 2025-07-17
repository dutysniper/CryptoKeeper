//
//  MainScreenAssembler.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

final class MainScreenAssembler {
	func assembly(onExit: @escaping () -> Void, onTransit: @escaping (_ coin: MainScreenModel.ViewModel.CurrencyDisplay) -> Void) -> MainScreenViewController {
		let viewController = MainScreenViewController()
		let networkManager = NetworkManager()
		let presenter = MainScreenPresenter(viewController: viewController, onExit: onExit, onTransit: onTransit)
		let interactor = MainScreenInteractor(presenter: presenter, networkManager: networkManager)

		viewController.interactor = interactor

		return viewController
	}
}
