//
//  DetailScreenViewController.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 17.07.2025.
//

import UIKit
import SnapKit

final class DetailScreenViewController: UIViewController {
	// MARK: - Public properties

	var viewModel: MainScreenModel.ViewModel.CurrencyDisplay?

	// MARK: - Private properties

	private lazy var downView = makeView()
	private lazy var marketStatisticLabel = makeLabel(text: "Market Statistic")
	private lazy var marketCapLabel = makeLabel(text: "Market capitalization")
	private lazy var supplyLabel = makeLabel(text: "Circulating supply")
	private lazy var capValueLabel = makeLabel(text: "test")
	private lazy var supplyValueLabel = makeLabel(text: "test")

	private enum PricePeriod: Int {
		case day = 0
		case week = 1
		case month = 2
		case year = 3
		case all = 4
	}

	private var selectedPeriod: PricePeriod = .day

	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .medium)
		label.textColor = .black

		return label
	}()

	private lazy var priceLabel: UILabel = {
		let label = UILabel()

		label.font = .systemFont(ofSize: 24, weight: .medium)
		label.textColor = .black

		return label
	}()

	private lazy var priceChangedLabel: UILabel = {
		let label = UILabel()

		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = UIColor(named: "GrayTextColor")

		return label
	}()

	private lazy var segmentedControl: UISegmentedControl = {
		let items = ["24H", "1W", "1M", "1Y", "All"]
		let sc = SegmentedControl(cornerRadius: 25)
		items.enumerated().forEach { index, title in
			sc.insertSegment(withTitle: title, at: index, animated: true)
		}
		sc.selectedSegmentIndex = 0
		sc.selectedSegmentTintColor = .white
		sc.tintColor = .black
		sc.backgroundColor = UIColor(named: "scBackgroundColor")
		sc.layer.borderWidth = 0
		sc.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
		sc.addTarget(self, action: #selector(periodChanged), for: .valueChanged)

		return sc
	}()

	// MARK: - Initialization

	init(viewModel: MainScreenModel.ViewModel.CurrencyDisplay?) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		configure()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}

	@objc private func backButtonTapped() {
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - SetupUI

private extension DetailScreenViewController {
	 func setupUI() {
		view.backgroundColor = UIColor(named: "DetailBackgroundColor")
		view.addSubview(downView)
		[nameLabel, priceLabel, priceChangedLabel, segmentedControl].forEach { subView in
			view.addSubview(subView)
		}
		 [marketStatisticLabel, marketCapLabel, supplyLabel, capValueLabel, supplyValueLabel].forEach { subView in
			 downView.addSubview(subView)
		 }
	}

	func makeLabel(text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		switch text {
		case "Market Statistic":
			label.font = .systemFont(ofSize: 20, weight: .medium)
			label.textColor = .black
		case "Market capitalization", "Circulating supply":
			label.font = .systemFont(ofSize: 14, weight: .semibold)
			label.textColor = UIColor(named: "GrayTextColor")
		default:
			label.font = .systemFont(ofSize: 14, weight: .semibold)
			label.textColor = .black
		}

		return label
	}

	func makeView() -> UIView {
		let downView = UIView()
		downView.layer.cornerRadius = 30
		downView.backgroundColor = UIColor(named: "BackgroundColor")

		return downView
	}

	func configure() {
		guard let viewModel = viewModel else { return }

		priceLabel.text = viewModel.price
		nameLabel.text = "\(viewModel.name) (\(viewModel.symbol))"
		updateChangeLabel(for: selectedPeriod)
		capValueLabel.text = "$\(viewModel.capitalization)"
		supplyValueLabel.text = " \(viewModel.supply) \(viewModel.symbol)"

	}

	private func updateChangeLabel(for period: PricePeriod) {
		var change = 0.0
		guard let dayPriceNumber = Double(viewModel?.priceChange.replacingOccurrences(of: "%", with: "") ?? "") else
		{ return }

		switch period {
		case .day:
			change = dayPriceNumber
		case .week:
			change = viewModel?.priceChangeInWeek ?? 0
		case .month:
			change = viewModel?.priceChangeInMonth ?? 0
		case .year:
			change = viewModel?.priceChangeInYear ?? 0
		case .all:
			change = viewModel?.priceChangeInAllTime ?? 0
		}

		let changeString = String(format: "%.2f%%", change)
		priceChangedLabel.text = (changeString)
		priceChangedLabel.textColor = change >= 0 ? .systemGreen : .systemRed
	}

	@objc private func periodChanged(_ sender: UISegmentedControl) {
		guard sender.selectedSegmentIndex >= 0 && sender.selectedSegmentIndex <= PricePeriod.all.rawValue else {
			return
		}
		guard let period = PricePeriod(rawValue: sender.selectedSegmentIndex) else { return }
		selectedPeriod = period
		updateChangeLabel(for: period)
	}
}

// MARK: - Layout

private extension DetailScreenViewController {
	func layout() {
		nameLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
		}

		priceLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(nameLabel.snp.bottom).offset(12)
		}

		priceChangedLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(priceLabel.snp.bottom).offset(8)
		}

		segmentedControl.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(20)
			make.top.equalTo(priceChangedLabel.snp.bottom).offset(20)
			make.height.equalTo(60)
		}

		downView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalToSuperview().multipliedBy(0.2)
			make.bottom.equalToSuperview().offset(16)
		}
		marketStatisticLabel.snp.makeConstraints { make in
			make.top.leading.equalToSuperview().offset(16)
		}
		marketCapLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(16)
			make.top.equalTo(marketStatisticLabel.snp.bottom).offset(16)
		}
		supplyLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(16)
			make.top.equalTo(marketCapLabel.snp.bottom).offset(16)
		}
		capValueLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.top.equalTo(marketCapLabel.snp.top)
		}

		supplyValueLabel.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.top.equalTo(supplyLabel.snp.top)
		}
	}
}

// MARK: - Safe Array Extension
extension Array {
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

final class SegmentedControl: UISegmentedControl {
	private var cornerRadius: CGFloat

	init(cornerRadius: CGFloat) {
		self.cornerRadius = cornerRadius
		super.init(frame: .zero)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = cornerRadius

		guard selectedSegmentIndex >= 0,
			  let selectedSegment = subviews[numberOfSegments] as? UIImageView else {
			return
		}

		selectedSegment.image = nil
		selectedSegment.tintColor = .black
		selectedSegment.backgroundColor = .white
		selectedSegment.layer.removeAnimation(forKey: "SelectionBounds")
		selectedSegment.layer.cornerRadius = cornerRadius - layer.borderWidth
		selectedSegment.bounds = CGRect(origin: .zero, size: CGSize(
			width: selectedSegment.bounds.width,
			height: bounds.height - layer.borderWidth * 2
		))
	}
}
