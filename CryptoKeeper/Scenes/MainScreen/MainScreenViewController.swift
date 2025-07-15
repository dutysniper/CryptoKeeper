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
		view.backgroundColor = .yellow
		interactor?.fetch()
	}

	// MARK: - Public methods
	// MARK: - Private methods
}

// MARK: - IMainScreenViewController

extension MainScreenViewController: IMainScreenViewController {
	func displayCurrencies(viewModel: MainScreenModel.ViewModel) {
		print(viewModel.data.first)
	}
}
