//
//  MainScreenInteractor.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol IMainScreenInteractor {
	func fetch()
	func sortCurrencies(descending: Bool, currencies: [MainScreenModel.ViewModel.CurrencyDisplay])
	func closeScreen()
	func openDetailScreen(coin: MainScreenModel.ViewModel.CurrencyDisplay)
}

final class MainScreenInteractor: IMainScreenInteractor {
	// MARK: - Public properties

	// MARK: - Dependencies

	private var presenter: IMainScreenPresenter?
	private var networkManager: INetworkManager?

	// MARK: - Initialization

	init(presenter: IMainScreenPresenter?, networkManager: INetworkManager) {
		self.presenter = presenter
		self.networkManager = networkManager
	}
	// MARK: - Public methods
	
	func fetch() {
		networkManager?.fetchData(completion: { [weak self] result in
			switch result {
			case .success(let response):
				print("Капитализация \(response.first?.metrics.marketCap.capitalization)")
				let response = MainScreenModel.Response(data: response)
				self?.presenter?.present(response: response)
			case .failure(let error):
				print(error.localizedDescription)
			}
		})
	}

	func sortCurrencies(descending: Bool, currencies: [MainScreenModel.ViewModel.CurrencyDisplay]) {

		let sortedCurrencies = currencies.sorted {
			let price1 = $0.priceChange
			let price2 = $1.priceChange
			return descending ? price1 < price2 : price1 > price2
		}

		presenter?.present(sortedResponse: sortedCurrencies)
	}

	func closeScreen() {
		print("logout interactor")
		presenter?.popToLogin()
	}

	func openDetailScreen(coin: MainScreenModel.ViewModel.CurrencyDisplay) {
		presenter.op
	}
	// MARK: - Private methods
}
