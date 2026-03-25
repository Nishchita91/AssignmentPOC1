//
//  ViewController.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 24/03/26.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel = LoginViewModel()
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTextfields()
    }
    
    // MARK: - Actions
    
    @IBAction func loginTapped() {
        // Save login session
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        navigateToHome()
    }
    
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

extension LoginViewController {
    
    private func setupUI() {
        errorLabel.isHidden = true
        submitButton.isEnabled = false
    }
    
    private func setupTextfields() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        
        updateUI()
    }
    
    private func updateUI() {
        
        submitButton.isEnabled = viewModel.isFormValid
        
        if let error = viewModel.errorMessage {
            errorLabel.text = error
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
        
        if emailTextField.text != "" {
            emailTextField.layer.borderWidth = viewModel.isValidEmail ? 0 : 1
            emailTextField.layer.borderColor = UIColor.red.cgColor
        }
        
        if passwordTextField.text != "" {
            passwordTextField.layer.borderWidth = viewModel.isValidPassword ? 0 : 1
            passwordTextField.layer.borderColor = UIColor.red.cgColor
        }
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
