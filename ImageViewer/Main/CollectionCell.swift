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
    
    var dogFilename: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        dogType.textColor = .white
        fileName.textColor = .white
        self.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
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
            dogType.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            dogType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            fileName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            fileName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            fileName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dogFilename: String?) {
        if let dogFilename = dogFilename {
            self.dogFilename = dogFilename
            self.imageView.set(fromUrl: dogFilename) { [weak self] data in
                if self?.dogFilename == dogFilename {
                    self?.imageView.image = data
                }
            }
            let dogElements = dogFilename.components(separatedBy: "/")
            dogType.text = dogElements[dogElements.count - 2]
            fileName.text = dogElements[dogElements.count - 1]
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        dogFilename = ""
    }
}
