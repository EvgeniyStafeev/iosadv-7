//
//  PostModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 18.11.2022.
//  Copyright © 2022 aserdiuk. All rights reserved.
//

import Foundation
import UIKit

public let itemSize = (UIScreen.main.bounds.width - 48)/4

// структура поста для DragAndDrop
public struct Post {
    public var autor: String
    public var description: String
    public var image: UIImage?
    public var likes: Int
    public var views: Int
}

public var posts : [Post] = [
    Post(autor: "В Мире Животных", description: "Котик", image: UIImage(named: "krasivye-kartinki-kotov-31"), likes: 2, views: 12),
    Post(autor: "Ждун", description: "Ждун-Ждуныч", image: UIImage(named: "5631"), likes: 5, views: 1112),
]

public var postSample = Post(autor: "Drag&Drop", description: "", image: UIImage(), likes: 0, views: 0)




