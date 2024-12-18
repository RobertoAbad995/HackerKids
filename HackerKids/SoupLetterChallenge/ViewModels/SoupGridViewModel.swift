//
//  SoupGridViewModel.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/25/24.
//

import Foundation
import UIKit

class SoupGridViewModel: ObservableObject {
    @Published var gridSize: Int = 0
    @Published var difficultyLevel: DifficultyLevel = .easy
    @Published var grid: [[Character]] = []
    @Published var challengeWords: [String] = ["GREEN", "OSO", "ROBERTO", "WEED", "SATURNO", "LAU♡"]
    @Published var selectedPositions: [GridPosition] = [] // Posiciones seleccionadas temporalmente
    @Published var correctWordsPositions: Set<GridPosition> = [] // Palabras correctamente seleccionadas
    @Published var foundWords: Set<String> = [] // Palabras encontradas
    @Published var win: Bool = false
    @Published var counter: Int = 0
    let isIPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    @Published private(set) var tiempoTranscurrido = 0 // Tiempo en segundos
    private var timer: Timer?

    var tiempoFormateado: String {
        let minutos = tiempoTranscurrido / 60
        let segundosRestantes = tiempoTranscurrido % 60
        return String(format: "%02d:%02d", minutos, segundosRestantes)
    }

    func startGame() {
        //START NEW GAME
        //GENERAR ARRAY VACIO
        let gridLimit = getGridSize()
        gridSize = gridLimit
        grid = Array(repeating: Array(repeating: SoupChallengeConstants.emptyChar, count: gridLimit), count: gridLimit)
        selectedPositions = []
        correctWordsPositions = []
        foundWords.removeAll()
        win = false
        //COLOCAR LAS PALABRAS
        placeWordsInGrid()
        // Rellenar el resto con letras aleatorias
        fillEmptySpaces()
        detenerTimer()
        tiempoTranscurrido = 0
        iniciarTimer()
    }
    func getGridSize() -> Int {
        if isIPad {
            return 15
        } else {
            return 14
        }
    }

    func generateRandomGrid(_ size: Int) {
        grid = (0..<size).map { _ in
            (0..<size).map { _ in
                SoupChallengeConstants.alphabet.randomElement() ?? "A"
            }
        }
    }
    func placeWordsInGrid() {
        for word in challengeWords {
            var placed = false
            while !placed {
                //Si la palabra es muy larga no puede ser añadidda
                if word.count > gridSize {
                    placed = true
                }
                //Definimos la direccion de la palabra
                let direction = Direction.random()
                //definimos el punto de inicio de forma aleatoria
                let startRow = Int.random(in: 0..<gridSize)
                let startCol = Int.random(in: 0..<gridSize)
                //Verificar si la palabra cabe we
                if canPlaceWord(word, direction: direction, row: startRow, col: startCol) {
                    //Insertar la palabra como la direccion lo marca
                    placeWord(word, direction: direction, row: startRow, col: startCol)
                    placed = true
                }
            }
        }
    }
    // Verificar si la palabra puede ser colocada
    func canPlaceWord(_ word: String, direction: Direction, row: Int, col: Int) -> Bool {
        let length = word.count
        switch direction {
        case .horizontal:
            return col + length <= gridSize && (0..<length).allSatisfy { grid[row][col + $0] == SoupChallengeConstants.emptyChar }
        case .vertical:
            return row + length <= gridSize && (0..<length).allSatisfy { grid[row + $0][col] == SoupChallengeConstants.emptyChar }
        case .diagonal:
            return row + length <= gridSize && col + length <= gridSize && (0..<length).allSatisfy { grid[row + $0][col + $0] == SoupChallengeConstants.emptyChar }
        }
    }
    // Colocar la palabra en el grid
    func placeWord(_ word: String, direction: Direction, row: Int, col: Int) {
        let letters = Array(word)
        for (index, letter) in letters.enumerated() {
            switch direction {
            case .horizontal:
                grid[row][col + index] = letter
            case .vertical:
                grid[row + index][col] = letter
            case .diagonal:
                grid[row + index][col + index] = letter
            }
        }
    }
    // Rellenar los espacios vacíos con letras aleatorias
    func fillEmptySpaces() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == SoupChallengeConstants.emptyChar {
                    grid[row][col] = SoupChallengeConstants.alphabet.randomElement() ?? "A"
                }
            }
        }
    }
    // Validar la selección actual de letras
    func validateSelection() {
        // Convert the selected characters to a string
        let selectedWord = selectedPositions.map { String(grid[$0.row][$0.col]) }.joined()
        
        // Verify if the selected word is in the list of valid words
        if challengeWords.contains(selectedWord) {
            // Mark all selected positions as correct
            for position in selectedPositions {
                correctWordsPositions.insert(position) // Store individual positions as (row, col)
            }
            foundWords.insert(selectedWord)
            // Limpiar las posiciones seleccionadas después de validar
            clearCurrentSelection()
            if challengeWords.count == foundWords.count {
                win = true
                counter += 1
                detenerTimer()
            }
        } else {
            //La palabra correcta no es la misma, validar inicio de secuencia entonces
            // Obtener las primeras letras seleccionadas
            let prefix = selectedPositions.prefix(selectedPositions.count).map { String(grid[$0.row][$0.col]) }.joined()
            
            // Verificar si alguna palabra esperada comienza con ese prefijo
            if !challengeWords.contains(where: { $0.hasPrefix(prefix) }) {
                //se han seleccionado solo errores
                print("No existe esta secuencia: \(selectedWord)")
                if let last = selectedPositions.last {
                    selectedPositions = [last]
                }
            } else {
                print("secuencia ingresada: \(selectedWord)")
            }
        }
    }
    func getDirection(_ first: (row: Int, col: Int), second: (row: Int, col: Int)) -> Direction? {
        if first.row == second.row {
            return .horizontal
        } else if first.col == second.col {
            return .vertical
        } else if abs(first.row - second.row) == abs(first.col - second.col) {
            return .diagonal
        }
        return nil // Dirección no válida
    }
    
    func isCorrectPosition(row: Int, col: Int) -> Bool {
        return correctWordsPositions.contains(GridPosition(row: row, col: col))
    }
    // Limpiar las posiciones seleccionadas temporalmente
    func clearCurrentSelection() {
        selectedPositions.removeAll()
    }
    // Comprobar si una palabra ya ha sido encontrada
    func isWordFound(_ word: String) -> Bool {
        return foundWords.contains(word)
    }
    // Inicia el temporizador
    func iniciarTimer() {
        detenerTimer() // Asegura que no haya un timer previo corriendo
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tiempoTranscurrido += 1
        }
    }

    // Detiene el temporizador
    func detenerTimer() {
        timer?.invalidate()
        timer = nil
    }
    func addChallenge(challenge: ChallengeModel?) {
        if let challenge {
            self.difficultyLevel = challenge.diffuculty
            self.challengeWords = challenge.challengeWords
        }
        startGame()
    }
}
enum DifficultyLevel: String, Identifiable, CaseIterable {
    case easy
    case medium
    case hard
    case impossible
    case custom
    
    var id: String { self.rawValue }
}
// Definir las direcciones posibles
enum Direction {
    case horizontal
    case vertical
    case diagonal
    
    static func random() -> Direction {
        return [.horizontal, .vertical, .diagonal].randomElement()!
    }
}
struct GridPosition: Hashable {
    let row: Int
    let col: Int
}

