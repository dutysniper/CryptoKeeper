//
//  LoginScreenPresenter.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol ILoginScreenPresenter {
	func present(with response: LoginScreen.Response)
}

final class LoginScreenPresenter: ILoginScreenPresenter {

	// MARK: - Dependencies

	private weak var viewController: ILoginScreenViewController?

	// MARK: - Private properties

	private let onSuccess: () -> Void
	private let onFailure: (String) -> Void

	// MARK: - Initialization

	init(
		viewController: ILoginScreenViewController?,
		onSuccess: @escaping () -> Void,
		onFailure: @escaping (String) -> Void
	) {
		self.viewController = viewController
		self.onSuccess = onSuccess
		self.onFailure = onFailure
	}

	// MARK: - Public methods

	func present(with response: LoginScreen.Response) {
		response.isSuccess
		? onSuccess()
		: onFailure(response.errorMessage ?? "Неизвестная ошибка")
	}
}
