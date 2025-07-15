//
//  LoginScreenAssembler.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

final class LoginScreenAssembler {
	/// Сборка модуля авторизации
	/// - Parameter loginResultClosure: замыкание оповещающие о результате авторизации
	/// - Returns: viewController
	func assembly(
		onSuccess: @escaping () -> Void,
		onFailure: @escaping (String) -> Void
	) -> LoginScreenViewController {
		let viewController = LoginScreenViewController()
		let presenter = LoginScreenPresenter(
			viewController: viewController,
			onSuccess: onSuccess,
			onFailure: onFailure
		)
		let interactor = LoginScreenInteractor(presenter: presenter)

		viewController.interactor = interactor

		return viewController
	}
}
