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

	// MARK: - Dependencies
	// MARK: - Private properties

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

		label.font = .systemFont(ofSize: 24, weight: .bold)
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
		items.forEach { title in
			sc.insertSegment(withTitle: title, at: 0, animated: true)
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

	private lazy var marketCapLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16)
		return label
	}()

	private lazy var circulatingSupplyLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16)
		return label
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
		tabBarController?.tabBar.isHidden = false
		hidesBottomBarWhenPushed = false
		print(viewModel?.name)
		configure()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupUI()
	}

	@objc private func backButtonTapped() {
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - SetupUI

private extension DetailScreenViewController {
	private func setupUI() {
		view.backgroundColor = UIColor(named: "BackgroundColor")
		[nameLabel, priceLabel, priceChangedLabel, segmentedControl, marketCapLabel, circulatingSupplyLabel].forEach { subView in
			view.addSubview(subView)
		}
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
	}

	private func configure() {
		priceLabel.text = viewModel?.price
		nameLabel.text = "\(viewModel?.name ?? "Coin") (\(viewModel?.symbol ?? "name"))"
		updateChangeLabel(for: selectedPeriod)

	}

	private func updateChangeLabel(for period: PricePeriod) {
		var change = 0.0
		var periodText = ""

		switch period {
		case .day:
			change = viewModel?.priceChange ?? 0
			periodText = "24H"
		case .week:
			change = viewModel?.priceChangeInWeek ?? 0
			periodText = "1W"
		case .month:
			change = viewModel?.priceChangeInMonth ?? 0
		case .year:
			change = viewModel?.priceChangeInYear ?? 0
			periodText = "1Y"
		case .all:
			change = viewModel?.priceChangeInAllTime ?? 0
			periodText = "All"
		}

		let changeString = String(format: "%.2f%%", change)
		priceChangedLabel.text = "\(periodText): \(changeString)"
		priceChangedLabel.textColor = change >= 0 ? .systemGreen : .systemRed
	}

	@objc private func periodChanged(_ sender: UISegmentedControl) {
		guard let period = PricePeriod(rawValue: sender.selectedSegmentIndex) else { return }
		selectedPeriod = period
		updateChangeLabel(for: period)
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
