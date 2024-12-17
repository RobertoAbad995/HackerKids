//
//  ChallengeToView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 12/14/24.
//

import SwiftUI

struct ChallengeToView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var challengeToViewModel: ChallengeToViewModel = ChallengeToViewModel()
    @State var newWord: String = ""
    let onExit: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                Text("Challenge your friends!")
                    .font(.title)
                TextField("Challenger", text: $challengeToViewModel.challenge.challengerName)
                    .font(.title)
                    .foregroundColor(Color.blue)
                    .padding()
                Picker("Select difficulty", selection: $challengeToViewModel.challenge.diffuculty, content: {
                    Text("Easy").tag(DifficultyLevel.easy)
                    Text("Medium").tag(DifficultyLevel.medium)
                    Text("Hard").tag(DifficultyLevel.hard)
                    Text("Impossible").tag(DifficultyLevel.impossible)
                })
                HStack {
                    TextField("New Word", text: $newWord)
                        .font(.title)
                        .foregroundColor(Color.blue)
                    Button(action: {
                        challengeToViewModel.challenge.challengeWords.append(newWord)
                        newWord = ""
                    }, label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                    })
                    Spacer()
                }
                ForEach(challengeToViewModel.challenge.challengeWords, id: \.self) { word in
                    Text(word)
                }
                NavigationLink("Start Vs game!", destination: SoupChallengeView(onExit: {
                    self.presentationMode.wrappedValue.dismiss()
                }, challenge: challengeToViewModel.challenge))
                Spacer()
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    ChallengeToView(onExit: {})
}
