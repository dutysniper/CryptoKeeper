//
//  LoginScreenPresenter.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol ILoginScreenPresenter {

}

final class LoginScreenPresenter: ILoginScreenPresenter {

	// MARK: - Dependencies

	private weak var viewController: ILoginScreenViewController?

	// MARK: - Initialization

	init(viewController: ILoginScreenViewController?) {
		self.viewController = viewController
	}
}
