//
//  AlertControllerExtension.swift
//  TMSHomework-Lesson31
//
//  Created by Наталья Мазур on 31.03.24.
//

import Foundation
import UIKit

extension UIAlertController {
    func addTextFieldForDouble() {
        self.addTextField { textField in
            textField.keyboardType = .numbersAndPunctuation
            textField.delegate = self
            textField.tag = 1
        }
    }
    
    func addTextFieldForInt64() {
        self.addTextField { textField in
            textField.keyboardType = .numbersAndPunctuation
            textField.delegate = self
            textField.tag = 2
        }
    }
}

extension UIAlertController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
            let replacementTextHasDecimalSeparator = string.range(of: ".")
            
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
            
            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
                return false
            }
            
            if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
                return false
            } else {
                return true
            }

        } else if textField.tag == 2 {
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
            if string.rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
