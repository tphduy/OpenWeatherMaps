//
//  SceneDelegate.swift
//  OpenWeatherMaps
//
//  Created by Duy Tran on 22/06/2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: UIWindowSceneDelegate
    
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        (scene as? UIWindowScene)
            .map(UIWindow.init(windowScene:))
            .map(bootstrap(from:))
    }
    
    // MARK: Side Effects
    
    /// Sets up the root view controller and appearance then shows the window and makes it the key window.
    /// - Parameter window: The backdrop for your app’s user interface and the object that dispatches events to your views.
    private func bootstrap(from window: UIWindow) {
        self.window = window
        let builder = DailyForecastsBuilder()
        let viewController = builder.build()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
