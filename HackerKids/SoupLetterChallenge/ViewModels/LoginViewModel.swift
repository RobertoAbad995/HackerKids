//
//  File.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 2/2/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var player: PlayerUser?
    @Published var userSession: Bool = false
    @Published var playerImg: Image?

    func startLogin() {
        if let localPlayer = readLocalData(){
            self.player = localPlayer
            createSession()
            userSession = true
        }
    }
    func readLocalData() -> PlayerUser? {
        return PlayerUser(id: "12334555", name: "Roberto Abad", email: "roberto.rmzabad@gmail.com", password: "********", picture: nil)
    }
    func createSession() {
        self.playerImg = player?.getPlayerImage()
    }
    func signOff() {
        player = nil
        userSession = false
    }
}
