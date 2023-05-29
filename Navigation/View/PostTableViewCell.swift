//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Евгений Стафеев on 18.11.2022.
//  
//

import Foundation
import UIKit
import CoreData

class PostTableViewCell: UITableViewCell {

    var pid : Int = 0
    var imgPost : String = ""
    var likesPost : Int = 0
    var viewsPost : Int = 0

    struct ViewModel {
        let pid : Int
        let autor: String
        let descriptionText: String
        let likes : String
        let views: String
        let image: UIImage?
    }

    private lazy var autor : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ждун"
        label.textColor = colorTextColor
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var img : UIImageView = {
        let img = UIImageView()
        img.image =  UIImage(named: "5631")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .black
        return img
    }()
    
    private lazy var descriptionText : UILabel = {
        let descriptionText = UILabel()
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.text = "ждун-ждуныч"
        descriptionText.textColor = .systemGray
        descriptionText.font = UIFont.systemFont(ofSize: 14.0)
        descriptionText.numberOfLines = 0
        return descriptionText
    }()
    
    private lazy var likes : UILabel = {
        let likes = UILabel()
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.text = "Likes: 643"
        likes.textColor = colorTextColor
        likes.font = UIFont.systemFont(ofSize: 16.0)
        return likes
    }()
    
    private lazy var views : UILabel = {
        let views = UILabel()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.text = "Views: 893"
        views.textColor = colorTextColor
        views.font = UIFont.systemFont(ofSize: 16.0)
        return views
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        addConstraints()

        let tap = UITapGestureRecognizer(target: self, action: #selector(addToFavotire(_:)))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // функция выполняющаяся при двойном нажатие на пост в ленте постов
    @objc func addToFavotire(_ sender: UITapGestureRecognizer){

        let posts = CoreDataModel().getPosts()
        var postIndexes : [Int] = []

        if posts.isEmpty {
            print("post is empty")
            CoreDataModel().addToFavorite(pid: pid, autor: autor.text!, desc: descriptionText.text!, likes: likesPost, views: viewsPost, img: imgPost)
        } else {
            for p in posts {
                postIndexes.append(Int(p.pid))
            }

            if let index = postIndexes.firstIndex(of: pid) {
                print("Post-\(index) already in favorite")

            } else {
                CoreDataModel().addToFavorite(pid: pid, autor: autor.text!, desc: descriptionText.text!, likes: likesPost, views: viewsPost, img: imgPost)
            }
        }

    }

    public func setup(with viewModel: ViewModel) {
        self.autor.text = viewModel.autor
        self.descriptionText.text = viewModel.descriptionText

        let formattedString = NSLocalizedString("showLikesCount", comment: "")
        let string = String(format: formattedString, Int(viewModel.likes) ?? 0)

        self.likes.text = string
        self.views.text = "Views: \(viewModel.views)"
        self.img.image = viewModel.image

        self.pid = viewModel.pid
        self.imgPost = "viewModel.image"
        self.likesPost = Int(viewModel.likes) ?? 0
        self.viewsPost = Int(viewModel.views) ?? 0

    }

    func addViews(){
        self.contentView.addSubview(autor)
        self.contentView.addSubview(img)
        self.contentView.addSubview(descriptionText)
        self.contentView.addSubview(likes)
        self.contentView.addSubview(views)
    }

    func addConstraints(){
        NSLayoutConstraint.activate([
            autor.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            autor.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            autor.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            img.topAnchor.constraint(equalTo: autor.bottomAnchor, constant: 12),
            img.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            img.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            img.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),

            descriptionText.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 16),
            descriptionText.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            descriptionText.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            likes.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 16),
            likes.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            likes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            views.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 16),
            views.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

        ])
    }
}
