//
//  MainScreenModel.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import Foundation

enum MainScreenModel {
	struct Request{}

	struct Response: Decodable {
		let data: [CryptoCurrency]
	}
	
	struct ViewModel {
		let data: [CryptoCurrency]
	}
}

struct CryptoCurrency: Decodable {
	let id: String
	let symbol: String
	let name: String
	let metrics: Metrics
	
	struct Metrics: Decodable {
		let marketData: MarketData
		
		struct MarketData: Decodable {
			let priceUsd: Double
			let percentChangeUsdLast24Hours: Double?
			
			enum CodingKeys: String, CodingKey {
				case priceUsd = "price_usd"
				case percentChangeUsdLast24Hours = "percent_change_usd_last_24_hours"
			}
		}
		
		enum CodingKeys: String, CodingKey {
			case marketData = "market_data"
		}
	}
}
