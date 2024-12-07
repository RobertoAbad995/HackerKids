//
//  SoupGridView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupGridView: View {
    @State private var tiempoTranscurrido = 0 // Tiempo en segundos
    @State private var timer: Timer? = nil
    @ObservedObject var viewModel: SoupGridViewModel // Use @ObservedObject to watch for changes in the ViewModel

    var body: some View {
        VStack {
            if !viewModel.grid.isEmpty &&
                viewModel.grid.count == viewModel.gridSize &&
                viewModel.grid.allSatisfy({ $0.count == viewModel.gridSize }) {
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
                gridBody
                wordsListView
            } else {
                loadingGridBody
            }
        }
        .onAppear(perform: viewModel.iniciarTimer)
        .onDisappear(perform: viewModel.detenerTimer)
    }
    var gridBody: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: viewModel.gridSize)
        return VStack {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(0..<viewModel.gridSize, id: \.self) { row in
                    ForEach(0..<viewModel.gridSize, id: \.self) { col in
                        Button(action: {
                            // Agregar la letra seleccionada a la lista temporal
                            viewModel.selectedPositions.append(GridPosition(row: row, col: col))
                            
                            // Si la dirección de selección está completa, validar
                            if viewModel.selectedPositions.count >= 2 {
                                viewModel.validateSelection()
                            }
                            // Handle letter selection here if needed
                            print("Selected: \(viewModel.grid[row][col])")
                        }, label: {
                            SoupLetterView(viewModel: viewModel, row: row, col: col)
                        })
                        .id("\(row)-\(col)")
                    }
                }
            }
        }
        .padding(4)
        .background(Color.black)
        .cornerRadius(14)
    }
    // Grid de palabras que deben ser encontradas
    var wordsListView: some View {
        return VStack(alignment: .leading) {
            let columns = [GridItem(.flexible()), GridItem(.flexible())] // Una columna con palabras apiladas verticalmente
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(viewModel.challengeWords, id: \.self) { word in
                    let found = viewModel.isWordFound(word)
                    HStack {
                        Image(systemName: found ? "checkmark.circle":"questionmark.diamond")
                            .foregroundStyle(found ? .white:.black)
                        Text(word)
                            .font(.footnote)
                            .foregroundStyle(found ? .white:.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(found ? Color.green : Color.white.opacity(0.3)) // Marcar palabras encontradas
                    .cornerRadius(20) /// make the background rounded
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white, lineWidth: 5)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(UIColor.lightGray.toColor().opacity(0.3))
        .border(UIColor.lightGray.toColor().opacity(0.8))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white, lineWidth: 5)
        )
    }
    var loadingGridBody: some View {
        return VStack {
            Text("Cargando...")
                .padding()
        }
    }
}
extension UIColor {
    // Convierte UIColor a Color
    func toColor() -> Color {
        return Color(self)
    }
}
//#Preview {
//    SoupGridView(viewModel: SoupGridViewModel())
//}
