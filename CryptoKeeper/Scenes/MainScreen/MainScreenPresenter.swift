//
//  MainScreenPresenter.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

protocol IMainScreenPresenter {
	func present(response: MainScreenModel.Response)
	func present(sortedResponse: [MainScreenModel.ViewModel.CurrencyDisplay])
	func popToLogin()
	func presentDetailScreen(coin: MainScreenModel.ViewModel.CurrencyDisplay)
}

final class MainScreenPresenter: IMainScreenPresenter {

	// MARK: - Dependencies
	private weak var viewController: IMainScreenViewController?

	// MARK: - Private methods
	private var isAscendingSort = true
	private let onExit: () -> Void
	private let onTransit: () -> Void

	// MARK: - Initialization
	init(viewController: IMainScreenViewController?, onExit: @escaping () -> Void, onTransit: @escaping () -> Void) {
		self.viewController = viewController
		self.onExit = onExit
		self.onTransit = onTransit
	}

	// MARK: - Public methods
	func present(response: MainScreenModel.Response) {
		let viewModel = mapToViewModel(response: response)
		let sortedViewModel = viewModel.currencies.sorted {
			isAscendingSort ? $0.price < $1.price : $0.price > $1.price
		}
		viewController?.displayCurrencies(viewModel: viewModel)
	}

	func present(sortedResponse: [MainScreenModel.ViewModel.CurrencyDisplay]) {
		let viewModel = MainScreenModel.ViewModel(currencies: sortedResponse)
		viewController?.displayCurrencies(viewModel: viewModel)
	}

	func popToLogin() {
		print("logout presenter")
		onExit()
	}

	func presentDetailScreen(coin: MainScreenModel.ViewModel.CurrencyDisplay) {

	}

	// MARK: - Private methods
	private func mapToViewModel(response: MainScreenModel.Response) -> MainScreenModel.ViewModel {
		let currencies = response.data.map { currency in
			let price = formatPrice(currency.metrics.marketData.priceUsd)
			let (priceChange, color) = formatPriceChange(currency.metrics.marketData.percentChangeUsdLast24Hours)

			return MainScreenModel.ViewModel.CurrencyDisplay(
				id: currency.id,
				symbol: currency.symbol.uppercased(),
				name: currency.name,
				price: price,
				priceChange: priceChange,
				capitalization: String(currency.metrics.marketCap.capitalization),
				supply: String(currency.metrics.supply.circulating),
				changeColor: color
			)
		}

		return MainScreenModel.ViewModel(currencies: currencies)
	}

	private func formatPrice(_ price: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencySymbol = "$"
		formatter.maximumFractionDigits = 4
		return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
	}

	private func formatPriceChange(_ change: Double?) -> (String, UIColor) {
		guard let change = change else {
			return ("N/A", .gray)
		}

		let changeString = String(format: "%.2f%%", change)
		return (changeString, change >= 0 ? .systemGreen : .systemRed)
	}
}
