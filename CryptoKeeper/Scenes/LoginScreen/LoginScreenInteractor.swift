//
//  LoginScreenInteractor.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol ILoginScreenInteractor {
	func login(with Request: LoginScreen.Request)
}

final class LoginScreenInteractor: ILoginScreenInteractor {

	// MARK: - Private properties

	let loginData = LoginScreen.Request(login: "1234", password: "1234")

	// MARK: - Dependencies

	private var presenter: ILoginScreenPresenter?

	// MARK: - Initialization

	init(presenter: ILoginScreenPresenter?) {
		self.presenter = presenter
	}
	// MARK: - Public methods

	func login(with request: LoginScreen.Request) {
		let isSuccess = request.login == loginData.login && request.password == loginData.password
		presenter?.present(with: LoginScreen.Response(
			isSuccess: isSuccess,
			errorMessage: isSuccess ? nil : "Введены неправильный логин или пароль"
		))
	}
}
