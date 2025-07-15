//
//  NetworkManager.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

protocol INetworkManager {
	func fetchData(completion: @escaping (Result<[CryptoCurrency], Error>) -> Void)
}

final class NetworkManager: INetworkManager {
	private let baseURL = "https://data.messari.io/api/v1/assets"
	private let currencies = [
		"btc",
		"eth",
		"tron",
		"luna",
		"polkadot",
		"dogecoin",
		"tether",
		"stellar",
		"cardano",
		"xrp"
	]

	func fetchData(completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
		let symbols = currencies.joined(separator: ",")
		let urlString = "\(baseURL)?fields=id,symbol,name,metrics/market_data/price_usd,metrics/market_data/percent_change_usd_last_24_hours"

		guard let url = URL(string: urlString) else {
			completion(.failure(NetworkError.invalidURL))
			return
		}

		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data else {
				completion(.failure(NetworkError.noData))
				return
			}

			do {
				let response = try JSONDecoder().decode(MainScreenModel.Response.self, from: data)
				completion(.success(response.data))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	enum NetworkError: Error {
		case invalidURL
		case noData
	}

}
