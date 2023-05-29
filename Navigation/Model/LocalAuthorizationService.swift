//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 17.05.2023.
//
//

import Foundation
import LocalAuthentication

class LocalAuthorizationService {

    let context = LAContext()
    let policy : LAPolicy = .deviceOwnerAuthenticationWithBiometrics

    var error: NSError?

    var type : LABiometryType = .none

    // для авторизации
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, Error?) -> Void) {
        let result = context.canEvaluatePolicy(policy, error: &error)

        if result {
            context.evaluatePolicy(policy, localizedReason: "Verify your Identity") { result, error in
                authorizationFinished(result, error)
            }
        } else {
            print("Биометрия отключена")
        }

    }

    func canEvaluate() -> Int {
        let result = context.canEvaluatePolicy(policy, error: &error)

        if result {
            type = context.biometryType
            return type.rawValue
        }else {
            return 0
        }
    }
}

