//
//  LoginViewModel.swift
//  DU-ADM
//
//  Created by nishchita.gangadhara on 25/03/26.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // MARK: - Inputs
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    // MARK: - Outputs
    
    lazy var isValidEmail: Observable<Bool> = {
        email.map { email in
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        }
    }()
    
    lazy var isValidPassword: Observable<Bool> = {
        password.map { $0.count >= 8 && $0.count <= 15 }
    }()
    
    lazy var isFormValid: Observable<Bool> = {
        Observable.combineLatest(isValidEmail, isValidPassword) { $0 && $1 }
    }()
    
    lazy var errorMessage: Observable<String?> = {
        Observable.combineLatest(email, password, isValidEmail, isValidPassword)
            .map { email, password, isValidEmail, isValidPassword in
                
                if !email.isEmpty && !isValidEmail {
                    return "Enter a valid email"
                } else if !password.isEmpty && !isValidPassword {
                    return "Password must be 8–15 characters"
                }
                return nil
            }
    }()
}
