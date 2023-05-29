//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Евгений Стафеев on 20.11.2022.
//
//

import Foundation
import UIKit

class PhotosCollectionViewCell : UICollectionViewCell {

    // создаем картинку
    private lazy var img : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithName(with name: String) {
        self.img.image = UIImage(named: name)
    }

    func setupWithImage(with image: UIImage){
        self.img.image = image
    }

    func setupWithIndex(with index : Int){
        self.img.image = photos[index]
    }

    private func setupView() {
        self.addSubview(img)

        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: self.topAnchor),
            img.leftAnchor.constraint(equalTo: self.leftAnchor),
            img.rightAnchor.constraint(equalTo: self.rightAnchor),
            img.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}


