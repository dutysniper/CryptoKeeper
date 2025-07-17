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
	private var keychainManager: IKeychainManager?

	// MARK: - Initialization

	init(presenter: ILoginScreenPresenter?, keychainManager: IKeychainManager?) {
		self.presenter = presenter
		self.keychainManager = keychainManager
	}
	// MARK: - Public methods

	func login(with request: LoginScreen.Request) {
		let isSuccess = request.login == loginData.login && request.password == loginData.password
		if isSuccess {
			saveLogin()
		}
		presenter?.present(with: LoginScreen.Response(
			isSuccess: isSuccess,
			errorMessage: isSuccess ? nil : "Введены неправильный логин или пароль"
		))
	}

	private func saveLogin() {
		keychainManager?.saveCredentials(login: loginData.login, password: loginData.password)
	}
}
