//
//  NetworkManager.swift
//  Navigation
//
//  Created by Евгений Стафеев on 28.01.2023.
//  
//

import Foundation

enum AppConfiguration : String, CaseIterable {
    case first = "https://jsonplaceholder.typicode.com/todos/1"
    case second = "https://swapi.dev/api/planets/1"
}

struct SomeData {
    var data : String = ""
}

var HW1 = SomeData()
var HW2 = SomeData()

var residents : [String] = []
var residentsName : [String] = []

struct Planet : Codable {
    var name : String
    var rotationPeriod : String
    var orbitalPeriod : String
    var diameter : String
    var climate : String
    var gravity : String
    var terrain : String
    var surfaceWater : String
    var population : String
    var residents : [String]
    var films : [String]
    var created : String
    var edited : String
    var url : String
}

struct NetworkManager {
    static func request(for configuration: AppConfiguration) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)

        if let url = URL(string: configuration.rawValue) { // получаем url для запроса
            let task = urlSession.dataTask(with: url, completionHandler: { data, responce, error in

                if let parsedData = data { // разворачиваем опционал, проверяем полученные данные

                    switch configuration {
                    case .first:
                        let str = String(data: parsedData, encoding: .utf8) // преобразовываем полученные даные в строку

                        if let stringToSerilization = str { // разворачиваем опционал, проверяем полученные данные
                            let dataToSerilization = Data(stringToSerilization.utf8) // подготавливаем данные для преобразования в JSON

                            do {
                                if let json = try JSONSerialization.jsonObject(with: dataToSerilization, options: [] ) as? [String: Any] {
                                    if let title = json["title"] as? String {
                                        HW1.data = title
                                    }
                                }
                            } catch let error as NSError {
                                print("Failed to load: \(error.localizedDescription)")
                            }
                        }
                    case .second:
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let planet = try decoder.decode(Planet.self, from: parsedData)
                            HW2.data = planet.orbitalPeriod

                            residents = planet.residents
                            residentsName = [String](repeating: "", count: residents.count)
                            
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            })
            task.resume()
        }
    }

    static func request(for configuration: String, index: Int) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)

        if let url = URL(string: configuration) { // получаем url для запроса
            let task = urlSession.dataTask(with: url, completionHandler: { data, responce, error in

                if let parsedData = data { // разворачиваем опционал, проверяем полученные данные

                    let str = String(data: parsedData, encoding: .utf8) // преобразовываем полученные даные в строку

                    if let stringToSerilization = str { // разворачиваем опционал, проверяем полученные данные
                        let dataToSerilization = Data(stringToSerilization.utf8) // подготавливаем данные для преобразования в JSON

                        do {
                            if let json = try JSONSerialization.jsonObject(with: dataToSerilization, options: [] ) as? [String: Any] {
                                if let name = json["name"] as? String {
                                    residentsName[index] = name
                                }
                            }
                        } catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                        }
                    }
                }
            })
            task.resume()
        }
    }
}
