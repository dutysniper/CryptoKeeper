//
//  ViewController.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit
import SnapKit

protocol ILoginScreenViewController: AnyObject {

}

final class LoginScreenViewController: UIViewController {

	// MARK: - Public properties
	// MARK: - Dependencies

	var interactor: ILoginScreenInteractor?

	// MARK: - Private properties

	private lazy var robotImage = makeImage()
	private lazy var loginTextField = makeTextField(label: "Username")
	private lazy var passwordTextField = makeTextField(label: "Password")
	private lazy var loginButton = makeButton()

	private func makeLabel() -> UILabel {
		let label = UILabel()
		label.text = "SnapKit"
		label.font = .systemFont(ofSize: 24)
		label.textColor = .black

		view.addSubview(label)

		return label
	}
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
		view.backgroundColor = UIColor(named: "BackgroundColor")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}

	// MARK: - Public methods
	// MARK: - Private methods
}


// MARK: - ILoginScreenViewController

extension LoginScreenViewController: ILoginScreenViewController {}


// MARK: - SetupUI

private extension LoginScreenViewController {
	func setupUI() {

	}

	func makeImage() -> UIImageView {
		let imageView = UIImageView(image: UIImage(named: "robot"))

		view.addSubview(imageView)

		return imageView
	}

	func makeTextField(label: String) -> UITextField {
		let textField = UITextField()
		textField.placeholder = label
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor(named: "GrayTextColor"),
			.font: UIFont.systemFont(ofSize: 14)
		]

		textField.attributedPlaceholder = NSAttributedString(
			string: textField.placeholder ?? "",
			attributes: attributes
		)
		textField.backgroundColor = .white
		textField.keyboardAppearance = .light
		textField.layer.cornerRadius = 25

		let iconView = UIImageView(image: UIImage(named: label))

		iconView.contentMode = .scaleAspectFit
		let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 45))
		iconContainerView.addSubview(iconView)
		iconView.frame = CGRect(x: 10, y: 7.5, width: 30, height: 30)

		// Установка leftView
		textField.leftView = iconContainerView
		textField.leftViewMode = .always

		if label == "Password" {
			textField.isSecureTextEntry = true
		}

		view.addSubview(textField)

		return textField
	}

	func makeButton() -> UIButton {
		let button = UIButton()

		button.backgroundColor = UIColor(named: "loginButtonColor")
		button.tintColor = .white
		button.layer.cornerRadius = 25
		button.setTitle("Login", for: .normal)

		button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

		view.addSubview(button)
		return button
	}

	@objc func loginButtonTapped() {
		let request = LoginScreen.Request(login: loginTextField.text ?? "", password: passwordTextField.text ?? "")
		interactor?.login(with: request)
	}
}

// MARK: - Layout

private extension LoginScreenViewController {
	func layout() {
		robotImage.snp.makeConstraints { make in
			make.width.equalToSuperview().multipliedBy(0.8)
			make.height.equalToSuperview().multipliedBy(0.4)
			make.top.equalToSuperview().offset(48)
			make.centerX.equalToSuperview()
		}

		loginTextField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(16)
			make.height.equalTo(55)
		}

		passwordTextField.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(16)
			make.height.equalTo(55)
			make.top.equalTo(loginTextField.snp.bottom).offset(8)
			make.bottom.equalTo(loginButton.snp.top).offset(-16)
		}

		loginButton.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(16)
			make.height.equalTo(55)
			make.bottom.equalToSuperview().offset(-128)
		}
	}
}

// MARK: - UITextFieldDelegate

extension LoginScreenViewController: UITextFieldDelegate {
	
}
