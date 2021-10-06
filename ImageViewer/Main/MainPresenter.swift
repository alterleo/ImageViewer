//
//  MainPresenter.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 06.10.2021.
//

import Foundation

class MainPresenter {
    
    unowned var view: ViewControllerProtocol?
    var dogs = [DogModel]()
    let mainGroup = DispatchGroup()
    private let queue = DispatchQueue(label: "imageviewer.presenter", attributes: .concurrent)
    
    init(view: ViewControllerProtocol) {
        self.view = view
    }
    
    func fetchData() {
        for _ in 1...20 {
            mainGroup.enter()
            NetworkManager.fetchData() { [weak self] dog in
                defer { self?.mainGroup.leave() }
                guard let self = self else { return }
                print("\(dog.status)>>>[\(dog.message)]")
                
                if !self.dogs.contains(where: { $0.filename == dog.message} ) {
                    self.dogs.append(DogModel(filename: dog.message, fileDate: Date()))
                } else {
                    print("Dublicate: \(dog.message)")
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
}
