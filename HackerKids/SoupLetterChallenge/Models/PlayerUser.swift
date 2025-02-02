//
//  PlayerUser.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//
import SwiftUI
import Foundation

struct PlayerUser: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var password: String
    var picture: Data?
    
    func getPlayerImage() -> Image {
        if let pictureData = picture?.createImage() {
            return pictureData
        }
        return Image(systemName: "person")
    }
}
