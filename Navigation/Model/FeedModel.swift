//
//  FeedModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import Foundation

struct PostFeed {
    var title : String
}

struct FeedModel {
    let password : String = "secretWord"

    func check(word: String) -> Bool {
        password == word ? true : false
    }
}
