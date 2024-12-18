//
//  SoupChallengeView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupChallengeView: View {
    @Environment(\.presentationMode) private var presentationMode
    let onExit: () -> Void
    @StateObject private var viewModel = SoupGridViewModel()
    @State private var showExitConfirmation = false
    var challenge: ChallengeModel?
    
    
    init(onExit: @escaping (() -> Void), challenge: ChallengeModel? = nil) {
        self.onExit = onExit
        self.challenge = challenge
    }

    var body: some View {
        VStack {
            ScrollView {
                title
                gameView
                controls
                Button("Volver a Home") {
                                showExitConfirmation = true
                }
            }
        }
        .onAppear {
            viewModel.addChallenge(challenge: challenge)
        }
        .popover(isPresented: $viewModel.win) {
            VStack {
                Text("")
                Text("You won!")
                // Marcador de tiempo
                HStack {
                    Text("Tiempo:")
                        .font(.headline)
                    Text(viewModel.tiempoFormateado)
                        .font(.body)
                        .monospacedDigit()
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                controls
            }
        }
        .alert("¿Deseas salir del juego?", isPresented: $showExitConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Salir", role: .destructive, action: {
                self.presentationMode.wrappedValue.dismiss()
                onExit()
            })
        }
    }
    var title: some View {
        VStack {
            Text("Sopita challenge")
                .font(.largeTitle)
            Text("by RobertSoft")
                .font(.subheadline)
        }
    }
    var gameView: some View {
        SoupGridView(viewModel: viewModel)
    }
    var controls: some View {
        HStack {
            Button(viewModel.counter > 0 ? "Nuevo juego!":"Comenzar!") {
                viewModel.counter += 1
                viewModel.startGame()
            }
            .padding()
        }
    }
}
#Preview {
    SoupChallengeView(onExit: {})
}
