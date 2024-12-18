//
//  SoupGridView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import SwiftUI

struct SoupGridView: View {
    @ObservedObject var viewModel: SoupGridViewModel

    var body: some View {
        VStack {
            if !viewModel.grid.isEmpty &&
                viewModel.grid.count == viewModel.gridSize &&
                viewModel.grid.allSatisfy({ $0.count == viewModel.gridSize }) {
                timerView
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
        .padding(.horizontal, 4)
//        .background(Color.black)
//        .cornerRadius(14)
    }
    // Grid de palabras que deben ser encontradas
    var wordsListView: some View {
        return VStack(alignment: .leading) {
            let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] // Una columna con palabras apiladas verticalmente
            LazyVGrid(columns: columns) {
                ForEach(viewModel.challengeWords, id: \.self) { word in
                    let found = viewModel.isWordFound(word)
                    HStack {
                        Image(systemName: found ? "checkmark.circle":"questionmark.diamond")
                            .foregroundStyle(found ? .white:.black)
                        Text(word)
                            .foregroundStyle(found ? .white:.black)
                    }
                    .frame(maxWidth: .infinity)
                    .background(found ? Color.green : Color.white.opacity(0.3)) // Marcar palabras encontradas
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
    }
    var loadingGridBody: some View {
        return VStack {
            Text("Cargando...")
                .padding()
        }
    }
    var timerView: some View {
        // Marcador de tiempo
        HStack {
            Text("Tiempo:")
                .font(.headline)
            Text(viewModel.tiempoFormateado)
                .font(.body)
                .monospacedDigit()
            Spacer()
            Text("\(viewModel.foundWords.count)/\(viewModel.challengeWords.count)")
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}
#Preview {
    SoupGridView(viewModel: SoupGridViewModel())
}
