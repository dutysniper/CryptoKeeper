//
//  KeychainManager.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 17.07.2025.
//

import Foundation
protocol IKeychainManager {
	func saveCredentials(login: String, password: String)
	func getCredentials() -> (login: String, password: String)?
}

final class KeychainManager: IKeychainManager {
	private let service = "com.your.app.login"

	func saveCredentials(login: String, password: String) {
		save(login, key: "login")
		save(password, key: "password")
	}

	func getCredentials() -> (login: String, password: String)? {
		guard let login = get(key: "login"),
			  let password = get(key: "password") else {
			return nil
		}
		return (login, password)
	}

	private func save(_ value: String, key: String) {
		let query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: key,
			kSecValueData: value.data(using: .utf8)!
		] as CFDictionary

		SecItemDelete(query)
		SecItemAdd(query, nil)
	}

	private func get(key: String) -> String? {
		let query = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: service,
			kSecAttrAccount: key,
			kSecReturnData: kCFBooleanTrue!,
			kSecMatchLimit: kSecMatchLimitOne
		] as CFDictionary

		var result: AnyObject?
		SecItemCopyMatching(query, &result)

		guard let data = result as? Data else { return nil }
		return String(data: data, encoding: .utf8)
	}
}
