//
//  CheckerService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//  
//

import Foundation
import FirebaseAuth

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password : String, complition: @escaping (String) -> Void) // login
    func signUp(email: String, password : String, complition: @escaping (String) -> Void) //  register
}

class CheckerService : CheckerServiceProtocol{
    func checkCredentials(email: String, password : String, complition: @escaping (String) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                let result = error?.localizedDescription as? String
                    if let res = result {
                        complition(res)
                    }
            } else {
                complition("Success authorization")
            }
        }

    }

    func signUp(email: String, password : String, complition: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                let result = error?.localizedDescription as? String
                    if let res = result {
                        complition(res)
                    }
            } else {
                complition("Success registration")
            }
        }
    }


}
