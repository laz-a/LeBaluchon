//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by laz on 24/10/2022.
//

import UIKit

class CurrencyViewController: UIViewController {
    private let currencyModel = CurrencyViewModel()

    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var toCodeLabel: UILabel!
    @IBOutlet weak var toPickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        toPickerView.isHidden = true
        setEnableTextFields(false)

        currencyModel.getSymbols { getSymbols in
            do {
                let symbols = try getSymbols()
                self.toPickerView.reloadAllComponents()
                if let usdIndex = symbols.firstIndex(where: { $0.code == "USD" }) {
                    self.toPickerView.selectRow(usdIndex, inComponent: 0, animated: false)
                    self.pickerView(self.toPickerView, didSelectRow: usdIndex, inComponent: 0)
                }
                self.toPickerView.isHidden = false
                self.setEnableTextFields(true)
            } catch {
                self.displayAlertError(message: error.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation
    */

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fromTextField.resignFirstResponder()
    }

    @IBAction func editFromTextField(_ sender: UITextField) {
        convert()
    }

    private func displayAlertError(message: String) {
        let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(errorAlertController, animated: true)
    }

    private func setEnableTextFields(_ value: Bool) {
        toTextField.backgroundColor = value ? .white : .lightText
        fromTextField.backgroundColor = value ? .white : .lightText
        fromTextField.isEnabled = value
    }

    private func getToCode() -> String? {
        let toRow = toPickerView.selectedRow(inComponent: 0)
        if let toCode = currencyModel.symbols?[toRow] {
            return toCode.code
        }
        return nil
    }

    private func convert() {
        let from = "EUR"

        guard let amountText = fromTextField.text, !amountText.isEmpty else {
            toTextField.text = ""
            return
        }

        if let to = getToCode(), let amount = Double(amountText) {
            currencyModel.getConversion(from: from, to: to, amount: amount) { getResult in
                do {
                    let result = try getResult()
                    self.toTextField.text = String(format: "%.2f", result)
                } catch {
                    self.toTextField.text = ""
                    self.displayAlertError(message: error.localizedDescription)
                }
            }
        }
    }
}

extension CurrencyViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let availableCurrencies = currencyModel.symbols {
            return availableCurrencies.count
        }
        return 0
    }
}

extension CurrencyViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let availableCurrencies = currencyModel.symbols {
            return availableCurrencies[row].country
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let to = getToCode() {
            self.toCodeLabel.text = to
        }
        convert()
    }
}
