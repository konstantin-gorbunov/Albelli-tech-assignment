//
//  ViewController.swift
//  EnhanceWrapper
//
//  Created by Kostiantyn Gorbunov on 29/06/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var countOfThreadTextField: NSTextField?
    @IBOutlet weak var generateErrorButton: NSButton?
    @IBOutlet weak var stackView: NSStackView?
    
    // MARK: - IBActions - menus
    
    @IBAction func startSelected(_ sender: Any) {
        produceThreadPool()
    }
    
    // MARK: - private
    
    private func produceThreadPool() {
        let queue = DispatchQueue.global(qos: .utility)
        guard let countOfThread = countOfThreadTextField?.integerValue, countOfThread > 0, countOfThread < 1024 else {
            showAlert("Update your input data. Something is wrong.")
            return
        }
        let generateError = (generateErrorButton?.state == .on)
        for processIndex in 0..<countOfThread {
            queue.async { [weak self] in
                Thread.current.name = "\(processIndex)"
                do {
                    var string = "12345\0"
                    if generateError {
                        string = (processIndex > 0 && processIndex % 6 == 0) ? "12" : string
                        string = (processIndex > 0 && processIndex % 10 == 0) ? "12я35" : string
                    }
                    let result = try EnhancerManager.shared.execute(withInputString: string)
                    self?.addResultToScrollView("Thread: \(processIndex) Result: \(result)")
                } catch {
                    self?.addResultToScrollView("Thread: \(processIndex) Error: \(error)")
                }
            }
        }
    }
    
    private func showAlert(_ string: String) {
        let alert = NSAlert.init()
        alert.messageText = string
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    private func createTextField(_ string: String) -> NSTextField {
        let textField = NSTextField()
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBezeled = false
        textField.stringValue = string
        return textField
    }
    
    private func addResultToScrollView(_ string: String) {
        DispatchQueue.main.async { [weak self] in
            if let textField = self?.createTextField(string) {
                self?.stackView?.addArrangedSubview(textField)
                textField.sizeToFit()
            }
        }
    }
}
