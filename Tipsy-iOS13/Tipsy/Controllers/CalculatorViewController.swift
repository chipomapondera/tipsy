//
//  CalculatorViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var tip = 0.10
    var numberOfPeople = 2
    var billTotal = 0.0
    var finalResult = "0.0"
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        //Dismiss the keyboard when the user chooses one of the tip values
        billTextField.endEditing(true)
        
        //Deselect all tip buttons via IBOutlets:
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        
        //Make the button that triggered the IBAction selected:
        sender.isSelected = true
        
        //Get the current title of the button that was pressed
        let buttonTitle = sender.currentTitle!
        
        //Remove the last character (%) from the tile then turn it back into a String
        let buttonTitleMinusPercentage = String(buttonTitle.dropLast())
        
        //Turn the String into a Double
        let buttonTitleAsNumber = Double(buttonTitleMinusPercentage)!
        
        //Divide the percent expressed out of 100 into a decimal eg. 10 becomes 0.1
        tip = buttonTitleAsNumber / 100
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        //Get the stepper value using sender.value, round it down to a whole number
        //then set it as the text in the splitNumberLabel
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        
        //Set the numberOfPeople property as the value of the stepper as a whole number
        numberOfPeople = Int(sender.value)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        //Get the text the user typed in the BillTextField
        let bill = billTextField.text!
        
        //If the text is not an empty String ""
        if bill != "" {
            //Turn the bill from a String eg. "123.50" to an actual String with decimal places
            //eg. 125.50
            billTotal = Double(bill)!
            
            //Multiply the bill by the tiip percentage and divide by
            //the number of people to split the bill
            let result = billTotal * (1 + tip) / Double(numberOfPeople)
            
            //Round the result to 2 decimal places and turn it into a String
            finalResult = String(format: "%.2f", result)
        }
        
        //In Main.storyboard there is a segue between CalculatorVC and ResultsVC with the identifier "goToResult"
        //This line triggers the segue to happen
        self.performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    //This method gets triggered just before the segue starts
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //If the currently triggered segue is the "goToResult" segue
        if segue.identifier == "goToResult" {
            
            //Get hold of the instance of the destination VC and type cast it to a ResultViewController
            let destinationVC = segue.destination as! ResultsViewController
            
            //Set the destination ResultsViewController properties
            destinationVC.result = finalResult
            destinationVC.tip = Int(tip * 100)
            destinationVC.split = numberOfPeople
        }
    }

}

