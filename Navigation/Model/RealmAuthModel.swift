//
//  RealmAuthModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 13.04.2023.
//  
//

import Foundation
import RealmSwift

class RealmUser : Object {
    @Persisted var login : String?
    @Persisted var password: String?
    @Persisted var lastAuth: Double? = nil

    convenience init(login: String, password: String) {
           self.init()
           self.login = login
           self.password = password
       }
}
