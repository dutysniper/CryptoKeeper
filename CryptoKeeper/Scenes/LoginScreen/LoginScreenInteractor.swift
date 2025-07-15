//
//  LoginScreenInteractor.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol ILoginScreenInteractor {

}

final class LoginScreenInteractor: ILoginScreenInteractor {

	// MARK: - Dependencies
	private var presenter: ILoginScreenPresenter?

	// MARK: - Initialization

	init(presenter: ILoginScreenPresenter?) {
		self.presenter = presenter
	}
}
