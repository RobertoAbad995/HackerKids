//
//  HomeView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/6/24.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: AboutAppViewModel = AboutAppViewModel()
    @State var infoView: Bool = false
    @State var gameRoute: GameRoute = .home
    var body: some View {
        NavigationStack {
            VStack {
                title
                startButton
                challengeButton
                highScoresButton
                Spacer()
                infoButton
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationDestination(for: GameRoute.self) { route in
                switch route {
                case .game:
                    SoupChallengeView(onExit: { gameRoute = .home })
                case .challenge:
                    ChallengeToView(onExit: {
                        gameRoute = .home
                    })
                case .highScores:
                    VStack {
                        Text("High scores")
                    }
                case .home:
                    HomeView()
                }
            }
            .popover(isPresented: $infoView) {
                ZStack {
                    Color.clear.blur(radius: 0.5)
                    AboutAppView(self.viewModel)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    var title: some View {
        VStack {
            Text("Sopita challenge")
                .font(.largeTitle)
                .fontWeight(.bold)
                .rotation3DEffect(
                    .degrees(20), // Ángulo de rotación
                    axis: (x: 1, y: 0, z: 0)
                )
                .foregroundColor(.blue)
                .shadow(color: .gray, radius: 10, x: 5, y: 5) // Sombra para mayor profundidad
            Text("by RobertSoft")
                .font(.subheadline)
                .fontWeight(.bold)
                .rotation3DEffect(
                    .degrees(20), // Ángulo de rotación
                    axis: (x: 1, y: 0, z: 0)
                )
                .foregroundColor(.blue)
                .shadow(color: .gray, radius: 10, x: 5, y: 5) // Sombra para mayor profundidad
        }
        .padding(.top, 250)
        .padding(.bottom, 10)
    }
    var startButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: SoupChallengeView(onExit: {
                self.gameRoute = .home
            }), label: {
                HomeButtonView(title: "Start game", icon: "play")
            })
        }
    }
    var challengeButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: ChallengeToView(onExit: {
                self.gameRoute = .home
            }), label: {
                HomeButtonView(title: "Vs challenge", icon: "play")
            })
        }
    }
    var highScoresButton: some View {
        withAnimation(.easeInOut(duration: 0.2)) {
            NavigationLink(destination: SoupChallengeView(onExit: {
                self.gameRoute = .highScores
            }), label: {
                HomeButtonView(title: "High scores", icon: "gamecontroller.circle")
            })
        }
    }
    var infoButton: some View {
        Button(action: {
            infoView.toggle()
        }) {
            HStack {
                Spacer()
                Image(systemName: "info.circle")
            }
            .padding()
        }
    }
}
enum GameRoute: Hashable {
    case home
    case game
    case challenge
    case highScores
}

#Preview {
    HomeView()
}
