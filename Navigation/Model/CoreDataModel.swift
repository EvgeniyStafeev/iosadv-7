//
//  CoreDataModel.swift
//  Navigation
//
//  Created by Евгений Стафеев on 13.04.2023.
//  
//

import Foundation
import CoreData

class CoreDataModel {

    var favoritePosts : [Favorite] = []

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Navigator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()

    init() {

    }

    @discardableResult func getPosts() -> [Favorite] {
        let answer = Favorite.fetchRequest()
        do {
            let posts = try persistentContainer.viewContext.fetch(answer)
            favoritePosts = posts
            return favoritePosts
        } catch {
            print(error)
        }
        return []
    }

    @discardableResult func getResults(query : String) -> [Favorite]{
        let answer = Favorite.fetchRequest()
        answer.predicate = NSPredicate(format: "autor LIKE %@", query)
        do {
            let posts = try persistentContainer.viewContext.fetch(answer)
            favoritePosts = posts
            return favoritePosts
            
        } catch {
            print(error)
        }
        return []
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func saveBackgroundContext () {
        let context = backgroundContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func deleteAll(){
        let answer = Favorite.fetchRequest()
        do {
            let posts = try persistentContainer.viewContext.fetch(answer)
            let context = persistentContainer.viewContext
            for post in posts {
                context.delete(post)
            }
            saveContext()
        } catch {
            print(error)
        }
    }

    func deleteFromFavorite(index : Int){
        let answer = Favorite.fetchRequest()
        do {
            let posts = try persistentContainer.viewContext.fetch(answer)
            let context = persistentContainer.viewContext

            context.delete(posts[index])
            saveContext()
        } catch {
            print(error)
        }
    }

    func addToFavorite(pid: Int, autor: String, desc: String, likes: Int, views: Int, img : String){
        backgroundContext.perform {
            let post = Favorite(context: self.backgroundContext)
            post.pid = Int32(pid)
            post.autor = autor
            post.desc = desc
            post.likes = Int32(likes)
            post.views = Int32(views)
            post.img = img
            self.saveBackgroundContext()
        }
    }
}
