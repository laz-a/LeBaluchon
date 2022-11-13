//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import UIKit

class CurrencyViewController: UIViewController {
    private let currencyModel = CurrencyViewModel()

    // Currency code corresponding to selected row PickerView
    private var targetCurrency: String {
        let toRow = toPickerView.selectedRow(inComponent: 0)
        return currencyModel.symbols[toRow].code
    }

    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromCodeLabel: UILabel!
    @IBOutlet weak var toCodeLabel: UILabel!
    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide PickerView and disable TextFields
        toPickerView.isHidden = true
        setEnableTextFields(false)

        // Get available currencies
        getSymbols()
    }

    /*
    // MARK: - Navigation
    */

    // Dismiss keyboard on tap gesture
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTextField.resignFirstResponder()
    }

    // Call convert function when textfield change
    @IBAction func editFromTextField(_ sender: UITextField) {
        convert()
    }

    // Change TextFields appearance
    private func setEnableTextFields(_ visible: Bool) {
        toTextField.backgroundColor = visible ? .white : .lightText
        fromTextField.backgroundColor = visible ? .white : .lightText
        fromTextField.isEnabled = visible
    }

    // Get available currencies symbols
    private func getSymbols() {
        activityIndicator.startAnimating()
        currencyModel.getSymbols { getSymbols in
            do {
                let symbols = try getSymbols()
                // Reload pickerview data
                self.toPickerView.reloadAllComponents()
                // Set fromCodeLabel to default currency (EUR)
                self.fromCodeLabel.text = self.currencyModel.defaultFromCurrency

                // Select $ as target currency if exist in available currencies
                if let toIndex = symbols.firstIndex(where: { $0.code == self.currencyModel.defaultToCurrency }) {
                    self.toPickerView.selectRow(toIndex, inComponent: 0, animated: false)
                    self.pickerView(self.toPickerView, didSelectRow: toIndex, inComponent: 0)
                }
                // Display currency PickerView
                self.toPickerView.isHidden = false
                // Enables TextFields
                self.setEnableTextFields(true)
            } catch {
                // Display alert error message
                self.displayAlertError(message: error.localizedDescription)
            }
            self.activityIndicator.stopAnimating()
        }
    }

    // Currency conversion
    private func convert() {
        // Get default from currency (EUR)
        let from = currencyModel.defaultFromCurrency
        // Test amount value
        guard let amountText = fromTextField.text, !amountText.isEmpty else {
            toTextField.text = ""
            return
        }

        // Try convert amount text to double
        if let amount = Double(amountText) {
            self.activityIndicator.startAnimating()
            // Convert amount according to selected currency
            currencyModel.getConversion(from: from, to: targetCurrency, amount: amount) { getResult in
                do {
                    let result = try getResult()
                    // Update result label
                    self.toTextField.text = String(format: "%.2f", result)
                } catch {
                    // Clear result label if error
                    self.toTextField.text = ""
                    // Display alert error
                    self.displayAlertError(message: error.localizedDescription)
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// PickerView dataSource
extension CurrencyViewController: UIPickerViewDataSource {
    // Set number of component
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Set number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Return number of currencies symbols
        return currencyModel.symbols.count
    }
}

// PickerView delegate
extension CurrencyViewController: UIPickerViewDelegate {
    // Set PickerView row title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyModel.symbols[row].country
    }

    // On select PickerView row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update toCodeLabel to display the new code currency
        self.toCodeLabel.text = targetCurrency
        // Converion
        convert()
    }
}
