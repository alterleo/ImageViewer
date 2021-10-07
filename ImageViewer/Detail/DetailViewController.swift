//
//  DetailViewController.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 06.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var dog: (filename: String?, fileDate: Date?)?
    let mainView = MainView()
    
    public override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.view.backgroundColor = .white
        
        if let dog = dog {
            if let dogDate = dog.fileDate, let dogFileName = dog.filename{
                
                let dogElements = dogFileName.components(separatedBy: "/")
                navigationItem.title = dogElements[dogElements.count - 1]
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm d MMM y"
                let dateString = dateFormatter.string(from: dogDate)
                mainView.labelDate.text = dateString
                
                mainView.imageView.set(fromUrl: dogFileName) { [weak self] data in
                    self?.mainView.imageView.image = data
                }
            }
        }
    }
    
}
