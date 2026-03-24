//
//  SplashViewController.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 19.03.2026.
//

import UIKit

final class SplashViewController: UIViewController {

    // MARK: - Properties

    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo_of_Unsplash"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }
    
    private func setupSplashView() {
        view.backgroundColor = UIColor(named: "YP Black")
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func presentAuthViewController() {
        guard let navigationController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? UINavigationController,
              let authVC = navigationController.viewControllers.first as? AuthViewController else {
            assertionFailure("Failed to instantiate AuthViewController")
            return
        }
        
        authVC.delegate = self
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
}

// MARK: - Private

private extension SplashViewController {

    func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                let alert = UIAlertController(
                    title: "Что-то пошло не так",
                    message: "Не удалось войти в систему",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            assertionFailure("No window")
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }
    
    func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                let alert = UIAlertController(
                    title: "Что-то пошло не так",
                    message: "Не удалось получить профиль",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
