//
//  DogModel.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 06.10.2021.
//

import Foundation

struct DogModelNetwork: Decodable {
    let message: String
    let status: String
}

struct DogModel {
    let filename: String
    let fileDate: Date
}
