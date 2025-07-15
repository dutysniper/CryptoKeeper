//
//  MainScreenPresenter.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol IMainScreenPresenter {
	func present(response: MainScreenModel.Response)
}

final class MainScreenPresenter: IMainScreenPresenter {
	// MARK: - Dependencies

	private weak var viewController: IMainScreenViewController?

	// MARK: - Private properties


	// MARK: - Initialization

	init(viewController: IMainScreenViewController?) {
		self.viewController = viewController
	}

	// MARK: - Public methods

	func present(response: MainScreenModel.Response) {
		
		let viewModel = MainScreenModel.ViewModel(data: response.data)
		viewController?.displayCurrencies(viewModel: viewModel)
	}
}
