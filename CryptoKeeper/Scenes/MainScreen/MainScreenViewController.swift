//
//  MainScreenViewController.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit
import SnapKit

protocol IMainScreenViewController: AnyObject {
	func displayCurrencies(viewModel: MainScreenModel.ViewModel)
}

final class MainScreenViewController: UIViewController {
	// MARK: - Dependencies
	var interactor: IMainScreenInteractor?
	// MARK: - Private properties
	
	private let activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .large)
		indicator.color = .black
		indicator.hidesWhenStopped = true
		return indicator
	}()

	private lazy var currencyListTableView = makeTableView()
	private lazy var cubeImageView = makeImageView()
	private lazy var menuView = makeView()
	private lazy var backgroundView = makeBackgroundView()
	private lazy var sortButton = makeSortButton()
	private lazy var trendingLabel = makeLabel()
	private lazy var learnMoreButton = makeButton()
	private lazy var affilateLabel: UILabel = {
		let label = UILabel()
		label.text = "Affilate program"
		label.textColor = .white
		label.font = .systemFont(ofSize: 26, weight: .regular)

		return label
	}()

	private var sortByDescending = true
	private var viewModel: MainScreenModel.ViewModel?

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		interactor?.fetch()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
}

// MARK: - IMainScreenViewController

extension MainScreenViewController: IMainScreenViewController {
	func displayCurrencies(viewModel: MainScreenModel.ViewModel) {
		self.viewModel = viewModel
		currencyListTableView.reloadData()
		activityIndicator.stopAnimating()
	}
}

// MARK: - Setup UI

private extension MainScreenViewController {

	func setupUI() {
		
		view.backgroundColor = UIColor(named: "pink")
		let titleLabel = UILabel()
		titleLabel.text = "Home"
		titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .semibold) // Для обычного title
		titleLabel.textColor = .white
		titleLabel.textAlignment = .left
		titleLabel.sizeToFit()

		let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
		containerView.addSubview(titleLabel)

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -48),
			titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
		])

		navigationItem.titleView = containerView
		navigationItem.largeTitleDisplayMode = .never

		let button = UIButton(type: .system)
		let largeConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold, scale: .large)
		button.setImage(UIImage(systemName: "ellipsis.circle.fill", withConfiguration: largeConfig), for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
		navigationItem.rightBarButtonItem?.tintColor = .white
		view.addSubview(activityIndicator)
		view.addSubview(affilateLabel)
		view.addSubview(learnMoreButton)
		view.addSubview(cubeImageView)
		view.addSubview(backgroundView)
		view.addSubview(currencyListTableView)
		view.addSubview(menuView)

		menuView.isHidden = true

		view.bringSubviewToFront(activityIndicator)
		activityIndicator.startAnimating()
	}

	func makeSortButton() -> UIButton {
		let button = UIButton()

		button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
		button.tintColor = .black
		button.backgroundColor = UIColor(named: "BackgroundColor")
		button.layer.cornerRadius = 15
		button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)

		return button
	}

	func makeLabel() -> UILabel {
		let label = UILabel()

		label.text = "Trending"
		label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
		label.textColor = .black

		return label
	}

	func makeBackgroundView() -> UIView {
		let backGroundView = UIView()
		backGroundView.layer.cornerRadius = 30
		backGroundView.backgroundColor = UIColor(named: "BackgroundColor")

		backGroundView.addSubview(trendingLabel)
		backGroundView.addSubview(sortButton)

		trendingLabel.snp.makeConstraints { make in
			make.leading.top.equalToSuperview().offset(16)
		}
		sortButton.snp.makeConstraints { make in
			make.trailing.top.equalToSuperview().inset(16)
		}
		return backGroundView
	}

	func makeTableView() -> UITableView {
		let tableView = UITableView()

		tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.reuseIdentifier)

		tableView.backgroundColor = UIColor(named: "BackgroundColor")
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 200
		tableView.separatorStyle = .none

		return tableView
	}

	func makeButton() -> UIButton {
		let button = UIButton(type: .system)

		button.setTitle("Learn more", for: .normal)
		button.layer.cornerRadius = 22
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
		button.backgroundColor = UIColor(named: "BackgroundColor")
		button.tintColor = .black

		return button
	}

	func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "cube")

		imageView.contentMode = .scaleAspectFit

		return imageView
	}

	func makeView() -> UIView {
		let menuView = UIView()
		menuView.isHidden = false
		menuView.backgroundColor = UIColor(named: "BackgroundColor")
		menuView.layer.cornerRadius = 20

		let refreshButton = UIButton()

		refreshButton.setTitle("Обновить", for: .normal)
		refreshButton.setTitleColor(.black, for: .normal)
		refreshButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
		refreshButton.configuration = .plain()
		refreshButton.configuration?.imagePadding = 4
		refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)

		let logOutButton = UIButton()

		logOutButton.setTitle("Выйти", for: .normal)
		logOutButton.setTitleColor(.black, for: .normal)
		logOutButton.setImage(UIImage(systemName: "trash"), for: .normal)
		logOutButton.configuration = .plain()
		logOutButton.configuration?.imagePadding = 8
		logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)


		menuView.addSubview(refreshButton)
		menuView.addSubview(logOutButton)

		refreshButton.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(8)
			make.leading.equalToSuperview().offset(8)
		}
		logOutButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(10)
			make.top.equalTo(refreshButton.snp.bottom).offset(12)
		}

		return menuView
	}

	@objc func refreshButtonTapped() {
		activityIndicator.startAnimating()
		interactor?.fetch()
	}

	@objc func logOut() {
		interactor?.closeScreen()
	}

	@objc func buttonTapped() {
		UIView.animate(withDuration: 0.3) {
			self.menuView.isHidden.toggle()
			self.view.layoutIfNeeded()
		}
	}

	@objc private func sortButtonTapped() {
		interactor?.sortCurrencies(descending: sortByDescending, currencies: viewModel?.currencies ?? [])
		sortByDescending.toggle()
	}
}

// MARK: - Layout

extension MainScreenViewController {
	func layout() {
		activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.height.equalTo(40)
		}

		affilateLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(30)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(45)
		}
		learnMoreButton.snp.makeConstraints { make in
			make.width.equalTo(160)
			make.height.equalTo(45)
			make.top.equalTo(affilateLabel.snp.bottom).offset(12)
			make.leading.equalToSuperview().offset(30)
		}

		menuView.snp.makeConstraints { make in
			make.width.equalTo(150)
			make.height.equalTo(100)
			make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
		}

		backgroundView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalToSuperview().multipliedBy(0.65)
		}

		cubeImageView.snp.makeConstraints { make in
			make.width.equalTo(300)
			make.height.equalTo(300)
			make.trailing.equalToSuperview().offset(35)
			make.bottom.equalTo(backgroundView.snp.top).offset(110)
		}

		currencyListTableView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(8)
			make.top.equalTo(backgroundView.snp.top).offset(48)
		}
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let viewModel = viewModel else { return 0 }
		return viewModel.currencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: CurrencyTableViewCell.reuseIdentifier,
			for: indexPath
		) as?  CurrencyTableViewCell else { return UITableViewCell() }

		guard let viewModel = viewModel else { return UITableViewCell() }

		cell.configure(with: viewModel.currencies[indexPath.row])

		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let coin = viewModel?.currencies[indexPath.row] else { return }
		print(coin.priceChangeInAllTime)
		interactor?.openDetailScreen(coin: coin)
	}
}

