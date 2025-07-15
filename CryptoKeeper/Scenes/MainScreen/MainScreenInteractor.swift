//
//  MainScreenInteractor.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol IMainScreenInteractor {
	func fetch()
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
				let response = MainScreenModel.Response(data: response)
				self?.presenter?.present(response: response)
			case .failure(let error):
				print(error.localizedDescription)
			}
		})
	}


	// MARK: - Private methods
}
