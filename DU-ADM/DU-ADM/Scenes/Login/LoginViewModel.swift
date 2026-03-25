//
//  LoginViewModel.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 25/03/26.
//

import Foundation

class LoginViewModel {
    
    // MARK: - Inputs
    var email: String = ""
    var password: String = ""
    
    // MARK: - Validation
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    var isValidPassword: Bool {
        return password.count >= 8 && password.count <= 15
    }
    
    var isFormValid: Bool {
        return isValidEmail && isValidPassword
    }
    
    // MARK: - Output (Error Message)
    
    var errorMessage: String? {
        if !isValidEmail && email != "" {
            return "Enter a valid email"
        } else if !isValidPassword && password != "" {
            return "Password must be 8–15 characters"
        }
        return nil
    }
}
