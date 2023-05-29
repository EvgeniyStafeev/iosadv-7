//
//  UserModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.01.2023.
//  
//

import Foundation
import UIKit

class TestUserService {
    let user : User

    init(user: User) {
        self.user = user
    }
}

class CurrentUserService {
    let user : User

    init(user: User) {
        self.user = user
    }
}

class User {
    let fio : String
    let avatar : UIImage
    let status : String

    init(fio: String, avatar: UIImage, status: String) {
        self.fio = fio
        self.avatar = avatar
        self.status = status
    }
}



