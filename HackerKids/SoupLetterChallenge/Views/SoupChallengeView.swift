//
//  SoupChallengeView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupChallengeView: View {
    @StateObject private var viewModel = SoupGridViewModel()

    var body: some View {
        VStack {
            ScrollView {
                title
                gameView
                controls
            }
        }
        .onAppear {
            viewModel.startGame()
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
    }
    var title: some View {
        VStack {
            Text("Sopita challenge")
                .font(.largeTitle)
            Text("by RobertSoft")
                .font(.subheadline)
        }
        .padding()
    }
    var gameView: some View {
        VStack {
            SoupGridView(viewModel: viewModel)
        }
        .padding()
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
    SoupChallengeView()
}
