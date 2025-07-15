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
	func assembly() -> LoginScreenViewController {
		let viewController = LoginScreenViewController()
		let presenter = LoginScreenPresenter(viewController: viewController)
		let interactor = LoginScreenInteractor(presenter: presenter)

		viewController.interactor = interactor

		return viewController
	}
}
