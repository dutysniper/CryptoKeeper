//
//  LoginScreenModel.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

enum LoginScreen {
	struct Request {
		let login: String
		let password: String
	}

	struct Response {
		let isSuccess: Bool
	}

	struct ViewModel {
		let errorMessage: String
	}
}
