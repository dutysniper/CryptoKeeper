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
	// MARK: - Public properties
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
	private lazy var moreButton = makeButton()
	private lazy var cubeImageView = makeImageView()
	private lazy var menuView = makeView()
	private lazy var backgroundView = makeBackgroundView()
	private lazy var sortButton = makeSortButton()
	private lazy var trendingLabel = makeLabel()



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
//		setupTableHeader()
		interactor?.fetch()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
		view.bringSubviewToFront(moreButton)
	}

	// MARK: - Public methods

	// MARK: - Private methods
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
		view.addSubview(activityIndicator)
		view.addSubview(cubeImageView)
		view.addSubview(backgroundView)
		view.addSubview(currencyListTableView)
		view.addSubview(menuView)
		view.addSubview(moreButton)
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
		label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
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

		var config = UIButton.Configuration.plain()
		config.image = UIImage(systemName: "ellipsis.circle.fill")
		config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 32)
		config.baseForegroundColor = .white

		button.configuration = config
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

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
		navigationController?.popToRootViewController(animated: true)
	}

	@objc func buttonTapped() {
		print("taptaptap")
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
			make.width.height.equalTo(80)
		}

		moreButton.snp.makeConstraints { make in
			make.height.width.equalTo(48)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
		}

		menuView.snp.makeConstraints { make in
			make.width.equalTo(150)
			make.height.equalTo(100)
			make.trailing.equalTo(moreButton.snp.trailing)
			make.top.equalTo(moreButton.snp.bottom).offset(8)
		}

		backgroundView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalToSuperview().multipliedBy(0.6)
		}

		cubeImageView.snp.makeConstraints { make in
			make.width.equalTo(250)
			make.height.equalTo(250)
			make.trailing.equalToSuperview().offset(35)
			make.bottom.equalTo(backgroundView.snp.top).offset(85)
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
}

