//
//  SoupLetterView.swift
//  HackerKids
//
//  Created by Roberto Ramirez on 9/26/24.
//

import SwiftUI

struct SoupLetterView: View {
    @ObservedObject var viewModel: SoupGridViewModel
    let row: Int
    let col: Int
    init(viewModel: SoupGridViewModel, row: Int, col: Int) {
        self.viewModel = viewModel
        self.row = row
        self.col = col
    }
    var body: some View {
        HStack {
            Text(String(viewModel.grid[row][col]))
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                .bold()
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 2, y: 2)
        }
        .padding(viewModel.isIPad ? 10:0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(setColor())
        .cornerRadius(6)
    }
    func setColor() -> Color {
        if viewModel.selectedPositions.contains(GridPosition(row: row, col: col)) {
            return .orange
        } else {
            return viewModel.isCorrectPosition(row: row, col: col) ? Color.green : Color.white
        }
    }
}

#Preview {
    SoupLetterView(viewModel: SoupGridViewModel(), row: 1, col: 1)
}
