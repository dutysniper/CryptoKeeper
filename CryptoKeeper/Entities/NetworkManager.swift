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
	private let targetSymbols: Set<String> = ["BTC", "ETH", "TRX", "LUNA", "DOT",
											  "DOGE", "USDT", "XLM", "ADA", "XRP"]

	func fetchData(completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
		let fields = "id,symbol,name,metrics/market_data/price_usd,metrics/market_data/percent_change_usd_last_24_hours,metrics/marketcap/current_marketcap_usd,metrics/all_time_high/percent_down,metrics/roi_data/percent_change_last_1_week,metrics/roi_data/percent_change_last_1_month,metrics/roi_data/percent_change_last_1_year,metrics/supply/circulating"
		let urlString = "\(baseURL)?fields=\(fields)&limit=500"

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
				let response = try JSONDecoder().decode(CryptoListResponse.self, from: data)
				let filtered = response.data.filter { self.targetSymbols.contains($0.symbol.uppercased()) }

				guard !filtered.isEmpty else {
					completion(.failure(NetworkError.noTargetData))
					return
				}
				DispatchQueue.main.async {
					completion(.success(filtered))
				}
			} catch {
				print("decoding error")
				print(error)
				completion(.failure(error))
			}
		}.resume()
	}

	enum NetworkError: LocalizedError {
		case invalidURL
		case noData
		case noTargetData

		var errorDescription: String? {
			switch self {
			case .invalidURL: return "Некорректный URL"
			case .noData: return "Данные не получены"
			case .noTargetData: return "Не найдены данные по целевым криптовалютам"
			}
		}
	}
}
