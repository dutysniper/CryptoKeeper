//
//  SceneDelegate.swift
//  CryptoKeeper
//
//  Created by Константин Натаров on 15.07.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {

		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)

		self.window = window
		self.window?.rootViewController = ViewController()
		self.window?.makeKeyAndVisible()

	}

	func sceneDidDisconnect(_ scene: UIScene) {

	}

	func sceneDidBecomeActive(_ scene: UIScene) {


		func sceneWillResignActive(_ scene: UIScene) {

		}

		func sceneWillEnterForeground(_ scene: UIScene) {

		}

		func sceneDidEnterBackground(_ scene: UIScene) {

		}
	}
}
