//
//  MainScreenModel.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

enum MainScreenModel {
	struct Request {
		let currencies: [CryptoCurrency]

	}

	struct Response {
		let data: [CryptoCurrency]
	}

	struct ViewModel {
		let currencies: [CurrencyDisplay]

		struct CurrencyDisplay {
			let id: String
			let symbol: String
			let name: String
			let price: String
			let priceChange: String
			let capitalization: String
			let supply: String
			let changeColor: UIColor
		}
	}
}

struct CryptoListResponse: Decodable {
	let data: [CryptoCurrency]
}

struct CryptoCurrency: Decodable {
	let id: String
	let symbol: String
	let name: String
	let metrics: Metrics

	struct Metrics: Decodable {
		let marketData: MarketData
		let marketCap: MarketCap
		let supply: Supply

		struct MarketData: Decodable {
			let priceUsd: Double
			let percentChangeUsdLast24Hours: Double?

			enum CodingKeys: String, CodingKey {
				case priceUsd = "price_usd"
				case percentChangeUsdLast24Hours = "percent_change_usd_last_24_hours"
			}
		}
		struct MarketCap: Decodable {
			let capitalization: Double

			enum CodingKeys: String, CodingKey {
				case capitalization = "current_marketcap_usd"
			}
		}

		struct Supply: Decodable {
			let circulating: Double

			enum CodingKeys: String, CodingKey {
				case circulating = "circulating"
			}
		}

		enum CodingKeys: String, CodingKey {
			case marketData = "market_data"
			case marketCap = "marketcap"
			case supply = "supply"
		}
	}
}

//struct CoinDetailResponse: Decodable {
//	let data: CoinDetailData
//
//	struct CoinDetailData: Decodable {
//		let marketData: MarketData
//		let supply: SupplyData
//
//		struct MarketData: Decodable {
//			let priceUsd: Double
//			let percentChangeUsdLast24Hours: Double?
//			let percentChangeUsdLast7Days: Double?
//			let percentChangeUsdLast1Year: Double?
//			let marketCap: Double?
//		}
//
//		struct SupplyData: Decodable {
//			let circulating: Double?
//		}
//	}
//}
