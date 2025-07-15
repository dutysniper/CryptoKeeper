//
//  LoginScreenAssembler.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

final class LoginScreenAssembler {
	/// Сборка модуля авторизации
	/// - Parameter onSuccess: замыкание оповещающие об успехе авторизации
	/// - Parameter onFailure: замыкание оповещающие о  неудаче авторизации
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
