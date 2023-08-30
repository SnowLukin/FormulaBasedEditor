//
//  TextHistoryManager.swift
//  braille-workspace-pages
//
//  Created by Snow Lukin on 27.05.2023.
//

import Foundation

final class TextHistoryManager: UndoManager {

    private var history: [String] = []
    private var index: Int = -1

    func registerChange(_ text: String) {
        if index < history.count - 1 {
            history = Array(history[0...index])
        }
        history.append(text)
        index += 1
    }

    override func undo() {
        guard canUndo else { return }
        index -= 1
        super.undo()
    }

    override func redo() {
        guard canRedo else { return }
        index += 1
        super.redo()
    }

    override var canUndo: Bool { return index > 0 }
    override var canRedo: Bool { return index < history.count - 1 }

    var currentText: String { return history[index] }
}
