//
//  ViewController.swift
//  iOS-Calculator
//
//  Created by cristina on 22/7/17.
//  Copyright © 2017 crisbarreiro. All rights reserved.
//

import UIKit

enum CalcOp : String {
    case Add = "op-suma"
    case Substract = "op-resta"
    case Multiply = "op-multiplica"
    case Divide = "op-divide"
}

class ViewController: UIViewController {

    @IBOutlet weak var icoSuma: UIImageView!
    @IBOutlet weak var icoResta: UIImageView!
    @IBOutlet weak var icoMultiplica: UIImageView!
    @IBOutlet weak var icoDivide: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    
    let currencyFormatter = NumberFormatter()
    
    var result : String? {
        didSet {
            if let result = result {
                lblResult.text = currencyFormatter.string(from: NSNumber(value: Double(result.replacingOccurrences(of: ",", with: "."))!))
            }
        }
    }
    
    var previousResult : String?
    
    var currentOperation : CalcOp? {
        willSet {
            resetIcons()
        }
        didSet {
            if let currentOperation = currentOperation {
                switch currentOperation {
                case .Add:
                    icoSuma.image = UIImage(named: "\(CalcOp.Add.rawValue)-on")
                case .Substract:
                    icoResta.image = UIImage(named: "\(CalcOp.Substract.rawValue)-on")
                case .Multiply:
                    icoMultiplica.image = UIImage(named: "\(CalcOp.Multiply.rawValue)-on")
                case .Divide:
                    icoDivide.image = UIImage(named: "\(CalcOp.Divide.rawValue)-on")
                }
            } else {
                resetIcons()
            }
        }
    }
    
    var previousOperation : CalcOp?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetCalculator()
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.maximumFractionDigits = 6
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.locale = Locale.current
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let key = sender.titleLabel!.text!
        
        switch key {
        case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0":
            if var newResult = result {
                newResult.append(key)
                result = newResult
            } else {
                result = key
            }
            case ",":
                if var newResult = result {
                    if newResult.range(of: ",") == nil {
                        newResult.append(".")
                        result = newResult
                    }
            }
            case "+":
                currentOperation = .Add
                applyOperation()
            case "-":
                currentOperation = .Substract
                applyOperation()
            case "×":
                currentOperation = .Multiply
                applyOperation()
            case "÷":
                currentOperation = .Divide
                applyOperation()
            case "=":
                applyOperation()
                currentOperation = nil
                previousOperation = nil
                previousResult = nil
            case "AC":
            resetCalculator()
            case "±":
                if var newResult = result, let currentValue = Double(newResult) {
                    newResult = String(-currentValue)
                    result = newResult	
            }
            case "%":
                if var newResult = result, let currentValue = Double(newResult) {
                    newResult = String(currentValue / 100)
                    result = newResult
            }
        default:
            print("Opción inexistente")
        }
    }
    
    func applyOperation() {
        if result != nil {
            if var newResult = result, let prevOperation = previousOperation, let prevResult = previousResult, let dblPreviousResult = Double(prevResult), let dblResult = Double(newResult) {
                switch prevOperation {
                case .Add:
                    newResult = String(dblPreviousResult + dblResult)
                case .Substract:
                    newResult = String(dblPreviousResult - dblResult)
                case .Multiply:
                    newResult = String(dblPreviousResult * dblResult)
                case .Divide:
                    if dblResult != 0 {
                        newResult = String(dblPreviousResult / dblResult)
                    } else {
                        newResult = "0"
                    }
                    
                }
                
                result = newResult
                previousResult = nil
                previousOperation = nil
            } else {
                previousOperation = currentOperation
                previousResult = result
                result = nil
            }
        }
    }

    func resetIcons() {
        icoSuma.image = UIImage(named: CalcOp.Add.rawValue)
        icoResta.image = UIImage(named: CalcOp.Substract.rawValue)
        icoMultiplica.image = UIImage(named: CalcOp.Multiply.rawValue)
        icoDivide.image = UIImage(named: CalcOp.Divide.rawValue)
    }
    
    func resetCalculator() {
        resetIcons()
        result = nil
        previousResult = nil
        currentOperation = nil
        previousOperation = nil
        lblResult.text = "0"
    }
}

