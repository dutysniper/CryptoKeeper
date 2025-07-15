//
//  ViewController.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit
import SnapKit

protocol ILoginScreenViewController: AnyObject {
	func clearTextFields()
}

final class LoginScreenViewController: UIViewController {

	// MARK: - Dependencies
	var interactor: ILoginScreenInteractor?

	// MARK: - UI Elements
	private lazy var robotImage = makeImage()
	private lazy var loginTextField = makeTextField(label: "Username")
	private lazy var passwordTextField = makeTextField(label: "Password")
	private lazy var loginButton = makeButton()

	// MARK: - Keyboard Handling Properties
	private var loginButtonBottomConstraint: Constraint?
	private let originalBottomOffset: CGFloat = -128

	//MARK: - Init

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
		setupUI()
		setupKeyboardObservers()
	}

	deinit {
		removeKeyboardObservers()
	}

	// MARK: - UI Setup
	private func setupUI() {
		[robotImage, loginTextField, passwordTextField, loginButton].forEach {
			view.addSubview($0)
		}

		loginTextField.delegate = self
		passwordTextField.delegate = self

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)

		layout()
	}

	@objc private func dismissKeyboard() {
		view.endEditing(true)
	}

	private func makeImage() -> UIImageView {
		let imageView = UIImageView(image: UIImage(named: "robot"))
		imageView.contentMode = .scaleAspectFit
		return imageView
	}

	private func makeTextField(label: String) -> UITextField {
		let textField = UITextField()
		textField.placeholder = label

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor(named: "GrayTextColor") ?? .gray,
			.font: UIFont.systemFont(ofSize: 14)
		]

		textField.attributedPlaceholder = NSAttributedString(
			string: textField.placeholder ?? "",
			attributes: attributes
		)

		textField.backgroundColor = .white
		textField.keyboardAppearance = .light
		textField.layer.cornerRadius = 25

		textField.autocorrectionType = .no
		textField.spellCheckingType = .no
		textField.autocapitalizationType = .none
		textField.textContentType = .none
		textField.passwordRules = nil

		if #available(iOS 12.0, *) {
			textField.textContentType = .newPassword
		} else {
			textField.textContentType = .init(rawValue: "")
		}

		let iconView = UIImageView(image: UIImage(named: label))
		iconView.contentMode = .scaleAspectFit

		let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 45))
		iconContainerView.addSubview(iconView)
		iconView.frame = CGRect(x: 10, y: 7.5, width: 30, height: 30)

		textField.leftView = iconContainerView
		textField.leftViewMode = .always

		if label == "Password" {
			textField.isSecureTextEntry = true
			textField.returnKeyType = .done
		} else {
			textField.returnKeyType = .next
		}

		return textField
	}

	private func makeButton() -> UIButton {
		let button = UIButton()
		button.backgroundColor = UIColor(named: "loginButtonColor")
		button.tintColor = .white
		button.layer.cornerRadius = 25
		button.setTitle("Login", for: .normal)
		button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
		button.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
		button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		return button
	}

	@objc private func loginButtonTapped(_ sender: UIButton) {
		buttonReleased(sender)
		let request = LoginScreen.Request(
			login: loginTextField.text ?? "",
			password: passwordTextField.text ?? ""
		)
		interactor?.login(with: request)
	}

	// Анимация при нажатии
	@objc private func buttonPressed(_ sender: UIButton) {
		UIView.animate(withDuration: 0.1) {
			sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
		}
	}

	// Анимация при отпускании
	@objc private func buttonReleased(_ sender: UIButton) {
		UIView.animate(withDuration: 0.1) {
			sender.transform = .identity
		}
	}


	// MARK: - Layout
	private func layout() {
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
			self.loginButtonBottomConstraint = make.bottom.equalToSuperview().offset(originalBottomOffset).constraint
		}
	}

	// MARK: - Keyboard Handling
	private func setupKeyboardObservers() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	private func removeKeyboardObservers() {
		NotificationCenter.default.removeObserver(self)
	}

	@objc private func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo,
			  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
			  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

		let keyboardHeight = keyboardFrame.height
		let safeAreaBottom = view.safeAreaInsets.bottom
		let neededOffset = keyboardHeight - safeAreaBottom

		UIView.animate(withDuration: duration) {
			self.loginButtonBottomConstraint?.update(offset: -neededOffset - 40)
			self.view.layoutIfNeeded()
		}
	}

	@objc private func keyboardWillHide(notification: NSNotification) {
		guard let userInfo = notification.userInfo,
			  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

		UIView.animate(withDuration: duration) {
			self.loginButtonBottomConstraint?.update(offset: self.originalBottomOffset)
			self.view.layoutIfNeeded()
		}
	}
}

// MARK: - UITextFieldDelegate
extension LoginScreenViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == loginTextField {
			passwordTextField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		return true
	}
}

// MARK: - ILoginScreenViewController
extension LoginScreenViewController: ILoginScreenViewController {
	func clearTextFields() {
		loginTextField.text = ""
		passwordTextField.text = ""
		loginTextField.becomeFirstResponder()
	}
}
