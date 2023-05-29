//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 26.01.2023.
//
//

import Foundation
import UIKit
import StorageService
import iOSIntPackage
import CoreData

class ProfileViewController : UIViewController {

    var user_1 : User = User(fio: "", avatar: UIImage() ,status: "")
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postTableCellIdentifier")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultTableCellIdentifier")
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = colorSecondaryBackground
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self

        return tableView
    }()

    private lazy var hiddenView : UIView = {
        var view = UIView()
        view.backgroundColor = colorMainBackground
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var hiddenAvatar : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "avatarImage")
        img.layer.cornerRadius = 50
        img.layer.masksToBounds = true
        img.isHidden = true
        img.layer.borderWidth = 3
        img.layer.borderColor = UIColor.white.cgColor
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        return img
    }()

    private lazy var hiddenCloseView : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "xmark")
        img.tintColor = .white
        img.isHidden = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        return img
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

        // если мы в дебаг версии то меняем цвет фона, иначе оставляем все как было
        #if DEBUG
            view.backgroundColor = .red
        #else
            view.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 250/255.0, alpha: 1)
        #endif

        addViews()
        addConstraints()
        addGestures()
        addNotification()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @objc func didAvatarClick(notification: Notification) {
        showAnimation()
    }

    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer){
        showAnimation()
    }


    @objc func tabClose(_ gestureRecognizer: UITapGestureRecognizer){
        closeAnimation()
    }


    func showAnimation() {

        let scaleCoef = self.hiddenView.frame.width / self.hiddenAvatar.frame.width


        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) {

            self.hiddenAvatar.isHidden = false
            self.hiddenView.isHidden = false

            self.hiddenAvatar.center = self.hiddenView.center
            self.hiddenAvatar.transform = CGAffineTransform(scaleX: scaleCoef, y: scaleCoef)
            self.hiddenAvatar.isUserInteractionEnabled = false

            self.hiddenView.alpha = 0.5

        } completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.hiddenCloseView.isHidden = false
            })
        }
    }

    func closeAnimation() {

    UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut) {
        self.hiddenAvatar.transform = CGAffineTransform(scaleX: 1, y: 1)

        self.hiddenAvatar.center = CGPoint(x: 66, y: 86)

        self.hiddenView.alpha = 0 // скрываем бекграунд

        self.hiddenCloseView.isHidden = true // скрываем кнопку закрыть

        self.hiddenAvatar.isUserInteractionEnabled = true // скрываем возможность кликать на скрытую аватарку пока она увеличена

    } completion: { _ in
        NotificationCenter.default.post(name: Notification.Name("closeClick!"), object: nil)
        self.hiddenAvatar.isHidden = true
    }
}

    func addNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didAvatarClick(notification:)),
                                               name: Notification.Name("avaClick!"),
                                               object: nil)
    }

    func addViews(){
        view.addSubview(tableView)
        view.addSubview(hiddenView)
        view.addSubview(hiddenAvatar)
        view.addSubview(hiddenCloseView)
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            hiddenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hiddenView.leftAnchor.constraint(equalTo: view.leftAnchor),
            hiddenView.rightAnchor.constraint(equalTo: view.rightAnchor),
            hiddenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            hiddenAvatar.topAnchor.constraint(equalTo: hiddenView.topAnchor, constant: 16),
            hiddenAvatar.leftAnchor.constraint(equalTo: hiddenView.leftAnchor, constant: 16),
            hiddenAvatar.widthAnchor.constraint(equalToConstant: 100),
            hiddenAvatar.heightAnchor.constraint(equalToConstant: 100),

            hiddenCloseView.topAnchor.constraint(equalTo: hiddenView.topAnchor, constant: 16),
            hiddenCloseView.rightAnchor.constraint(equalTo: hiddenView.rightAnchor, constant: -16),
            hiddenCloseView.widthAnchor.constraint(equalToConstant: 25),
            hiddenCloseView.heightAnchor.constraint(equalToConstant: 25),
        ])
    }

    func addGestures(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        self.hiddenAvatar.addGestureRecognizer(tapGestureRecognizer)

        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.tabClose(_:)))
        self.hiddenCloseView.addGestureRecognizer(tapGestureRecognizer2)


    }
    
}

extension ProfileViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0  {
            let profile = ProfileHeaderView()
            profile.setup(user: user_1)
            return profile
        }
        return nil
    }
}

extension ProfileViewController : UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        if section == 1 {
            return posts.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{

            let photosViewController = PhotosViewController()
            navigationController?.pushViewController(photosViewController, animated: false)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        if indexPath.section == 0 {
            return PhotoTableViewCell()
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "postTableCellIdentifier", for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableCellIdentifier", for: indexPath)
                return cell
            }

            let post = posts[indexPath.row]

            let PostViewModel = PostTableViewCell.ViewModel(
                pid : indexPath.row,
                autor: post.autor,
                descriptionText: post.description,
                likes: "\(post.likes)",
                views: "\(post.views)",
                image: post.image
            )
            cell.setup(with: PostViewModel)
            return cell

        } else {
            return tableView.dequeueReusableCell(withIdentifier: "defaultTableCellIdentifier", for: indexPath)
        }
    }
}

extension ProfileViewController : UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let description = posts[indexPath.row].description
        let image = posts[indexPath.row].image

        let itemDescription = NSItemProvider(object: NSString(string: description))
        let itemImage = NSItemProvider(object: image ?? UIImage())

        let dragItem1 = UIDragItem(itemProvider: itemDescription)
        let dragItem2 = UIDragItem(itemProvider: itemImage)

        return [dragItem2, dragItem1]
    }
}

extension ProfileViewController : UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        let img = session.canLoadObjects(ofClass: UIImage.self)
        let str = session.canLoadObjects(ofClass: NSString.self)

        return img || str
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {

        let destinationIndexPath = IndexPath(item: tableView.numberOfRows(inSection: 1), section: 1)
        var newPost = postSample

                for item in coordinator.items {
                    item.dragItem.itemProvider.loadObject(ofClass: NSString.self, completionHandler: { string, error in
                        if let desc = string {
                            newPost.description = desc as! String

                            posts.append(newPost)

                            DispatchQueue.main.async {
                                tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                            }
                        }
                    })

                    item.dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { image, error in

                        if let img = image {
                            newPost.image = img as? UIImage

                            posts.append(newPost)

                            DispatchQueue.main.async {
                                tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                            }
                        }
                    })
                }

    }
}
