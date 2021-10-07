//
//  MainPresenter.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 06.10.2021.
//

import Foundation
import CoreData
import UIKit

class MainPresenter {
    
    unowned var view: ViewControllerProtocol?
    var coreDogs = [NSManagedObject]()
    
    let mainGroup = DispatchGroup()
    private let queue = DispatchQueue(label: "imageviewer.presenter", attributes: .concurrent)
    
    init(view: ViewControllerProtocol) {
        self.view = view
    }
    
    /// Проверим загрузку данных по сети с нашего API
    func checkInternetAndLoadData() {
        NetworkManager.fetchData() { [weak self] dog in
            guard let self = self else { return }
            
            // связь есть? - обнуляем БД и запрашиваем порцию данных
            if let _ = dog {
                DispatchQueue.main.async {
                    self.deleteAllData()
                }
                self.fetchData()
            } else {
                DispatchQueue.main.async {
                    self.loadFromDB()
                    self.view?.reloadData()
                }
            }
        }
    }
    
    /// Очистка БД
    private func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dogs")
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteAllRequest)
        } catch let error as NSError {
            print("Some error with clearing DB: \(error), \(error.userInfo)")
        }
    }
    
    /// Загрузка из БД
    private func loadFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Dogs")
        
        do {
            coreDogs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Some error with loading from DB: \(error), \(error.userInfo)")
        }
    }
    
    /// Загрузка 20 данных из сети
    func fetchData() {
        for _ in 1...20 {
            mainGroup.enter()
            NetworkManager.fetchData() { [weak self] dog in
                defer { self?.mainGroup.leave() }
                guard let self = self else { return }
                
                if let dog = dog {
                    self.save(filename: dog.message)
                }
            }
        }
        
        queue.async {
            self.mainGroup.wait()
            DispatchQueue.main.async {
                self.view?.reloadData()
            }
        }
    }
    
    /// Построчное сохранение в базу и в массив
    private func save(filename: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Dogs", in: managedContext)!
        let dog = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let nowDate = Date()
        
        dog.setValue(filename, forKey: "filename")
        dog.setValue(nowDate, forKey: "fileDate")
        do {
            try managedContext.save()
            coreDogs.append(dog)
        } catch let error as NSError {
            print("Some error with saving into DB: \(error), \(error.userInfo)")
        }
        
    }
}
