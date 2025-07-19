//
//  CurrencyTableViewCell.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 16.07.2025.
//

import UIKit
import SnapKit

final class CurrencyTableViewCell: UITableViewCell {
	static let reuseIdentifier = "CurrencyTableViewCell"

	private let currencyName = UILabel()
	private let symbol = UILabel()
	private let priceUSD = UILabel()
	private let percentChangeUSD = UILabel()
	private let coinImage = UIImageView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = UIColor(named: "BackgroundColor")
		setupViews()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with currency: MainScreenModel.ViewModel.CurrencyDisplay) {
		contentView.backgroundColor = UIColor(named: "BackgroundColor")
		currencyName.text = currency.name
		symbol.text = currency.symbol
		priceUSD.text = String(currency.price)
		percentChangeUSD.text = String(currency.priceChange)
		coinImage.image = UIImage(named: currency.symbol.uppercased())
	}

	private func setupViews() {
		[currencyName, symbol, priceUSD, percentChangeUSD, coinImage].forEach {
			contentView.addSubview($0)
		}
		coinImage.contentMode = .scaleAspectFit
		coinImage.clipsToBounds = true

		currencyName.font = UIFont.systemFont(ofSize: 18)
		currencyName.textColor = .black

		priceUSD.font = UIFont.systemFont(ofSize: 18)
		priceUSD.textColor = .black

		symbol.font = UIFont.systemFont(ofSize: 14)
		symbol.textColor = UIColor(named: "GrayTextColor")

		percentChangeUSD.font = UIFont.systemFont(ofSize: 14)
		percentChangeUSD.textColor = UIColor(named: "GrayTextColor")

		coinImage.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalToSuperview().offset(16)
			make.width.height.equalTo(50)
		}
		currencyName.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalTo(coinImage.snp.trailing).offset(8)
		}
		symbol.snp.makeConstraints { make in
			make.bottom.equalToSuperview().offset(-8)
			make.top.equalTo(currencyName.snp.bottom).offset(4)
			make.leading.equalTo(coinImage.snp.trailing).offset(8)
		}
		priceUSD.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.top.equalToSuperview().offset(8)
		}
		percentChangeUSD.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.bottom.equalToSuperview().offset(-8)
			make.top.equalTo(priceUSD.snp.bottom).offset(8)
		}
	}
}
