//
//  AboutAppView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 1/26/25.
//

import SwiftUI

struct AboutAppView: View {
    @ObservedObject var viewModel: AboutAppViewModel
    @State private var showMailView = false
    init(viewModel: AboutAppViewModel = AboutAppViewModel(), showMailView: Bool = false) {
        self.viewModel = viewModel
        viewModel.getGitUser()
        self.showMailView = showMailView
    }
    var body: some View {
        VStack(spacing: 20) {
            Text("Sopita challenge")
                .font(.largeTitle)
            HStack(spacing: 0) {
                Text("by ")
                Button(action: {
                    openGitHub()
                }, label: {
                    Text("\(viewModel.gitHubUser?.login ?? "")")
                        .foregroundStyle(Color.blue)
                })
            }
            AsyncImage(url: URL(string: viewModel.gitHubUser?.avatarUrl ?? "")) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .frame(width: 130, height: 130)
            .padding(5)
            .background(Color.black)
            .clipShape(Circle())
            Text(viewModel.gitHubUser?.bio ?? "")
                .font(.body)
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "envelope")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                        .padding()
                        .clipShape(Circle())
                })
                .padding()
                .clipShape(Circle())
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 5, y: 5)
                Button(action: {
                    openGitHub()
                }, label: {
                    Image("gitIcon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                })
                .padding()
                .clipShape(Circle())
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 5, y: 5)
                Button(action: {
                    openUrl(.ig)
                }, label: {
                    Image("igIcon")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding()
                        .background(Color.pink)
                        .clipShape(Circle())
                })
                .padding()
                .clipShape(Circle())
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 5, y: 5)
            }
        }
        .padding()
        .sheet(isPresented: $showMailView) {
            MailView(
                recipients: [viewModel.developerEmailAddress],
                subject: "Consulta desde la app",
                body: "Hola, este es un mensaje generado desde la app."
            )
        }
    }
    func openGitHub() {
        openUrl(.github)
    }
    func openUrl(_ contactType: ContactSource){
        var url = URL(string: "")
        switch contactType {
        case .github:
            url = URL(string: "https://github.com/RobertoAbad505/")
        case .ig:
            url =  URL(string: "https://www.instagram.com/roberto.abad21/")
        case .mail:
            if viewModel.canSendEmailToDeveloper() {
                showMailView = true
            }
            return
        }
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
enum ContactSource {
    case ig
    case github
    case mail
}
