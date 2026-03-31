//
//  ViewController.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 24/03/26.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
}

extension LoginViewController {
    
    private func setupUI() {
        errorLabel.isHidden = true
        submitButton.isEnabled = false
    }
    
    @IBAction func loginTapped() {
        submitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self?.navigateToHome()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            return
        }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarVC
            window.makeKeyAndVisible()
        }
    }
}

extension LoginViewController {
    
    private func bindViewModel() {
        
        // MARK: - Input Binding
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        // MARK: - Output Binding
        
        // Enable button
        viewModel.isFormValid
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Error message
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.errorLabel.text = error
                self?.errorLabel.isHidden = (error == nil)
            })
            .disposed(by: disposeBag)
        
        // Email border
        viewModel.isValidEmail
            .subscribe(onNext: { [weak self] isValid in
                guard let self = self else { return }
                if !self.emailTextField.text!.isEmpty {
                    self.emailTextField.layer.borderWidth = isValid ? 0 : 1
                    self.emailTextField.layer.borderColor = UIColor.red.cgColor
                }
            })
            .disposed(by: disposeBag)
        
        // Password border
        viewModel.isValidPassword
            .subscribe(onNext: { [weak self] isValid in
                guard let self = self else { return }
                if !self.passwordTextField.text!.isEmpty {
                    self.passwordTextField.layer.borderWidth = isValid ? 0 : 1
                    self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                }
            })
            .disposed(by: disposeBag)
    }
}
