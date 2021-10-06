//
//  CollectionCell.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 06.10.2021.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    static let cellId = "mainCell"
    
    let imageView = UIImageView()
    let dogType = UILabel()
    let fileName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        
        contentView.addSubview(imageView)
        contentView.addSubview(dogType)
        contentView.addSubview(fileName)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        dogType.translatesAutoresizingMaskIntoConstraints = false
        fileName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dogType.bottomAnchor.constraint(equalTo: fileName.topAnchor, constant: -5),
            dogType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dogType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            fileName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            fileName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fileName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dog: DogModel) {
        let dogElements = dog.filename.components(separatedBy: "/")
        dogType.text = dogElements[dogElements.count - 2]
        fileName.text = dogElements[dogElements.count - 1]
    }
}
