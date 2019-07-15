//
//  DataManagement.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import Foundation
import CoreData
import UIKit




//Global context variable (use for fetching and storing data)
var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//Extension for the receipt entity
extension Receipt {
    //Function that returns Receipt data through the use of the receipt name
    class func FetchData (with receiptName: String) -> Receipt? {
        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        
        //NSPredicate to specify arguments for what to look up
        request.predicate = NSPredicate(format: "receiptName = %@", receiptName)
        
        //Attempts to find requested attribute/entities
        do {
            let receipts = try context.fetch(request)
            return receipts.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //A function that deletes the receipt
    func deleteReceipt() {
        //let item = Receipt.FetchData(with: itemName)
        //Does the actual deleting
        context.delete(self)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //----------------------------------------------------------------
    //----------Functions regardings items in the receipt-------------
    //----------------------------------------------------------------
    
    
    //Function that fethces the receipt items based on the receipt Name given and returns it
    //NOTE: WORK IN PROGRESS
    /*
    func FetchReceiptItems(receiptName: String) -> Receipt{
     
        AllItems:[ReceiptItems] = []
     
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
        //Creates fetch request for all items
        let myFetch:NSFetchRequest<ReceiptItems> = ReceiptItems.fetchRequest()
        let myPredicate = NSPredicate(format: "itemReceipt.receiptName == %@", receiptName)
        myFetch.predicate = myPredicate
     
        //Does the actual fetching of data
        do {
            let result = try context.fetch(myFetch)
            print(result.count)
            AllItems = result
        }
        catch {
            print(error)
        }
     
        return result
    }*/
}


//Function for saving data using core data
//Will mainly be used for saving receipt references
func SaveReceiptData (NameOfReceipt: String/*, ItemCost: Double*/) {
    
    //Creates variable for Container access
    let CreateReceipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context)
    CreateReceipt.setValue(NameOfReceipt, forKey: "receiptName")
    
    //save to container/core data
    do {
        try context.save()
    } catch {
        print(error)
    }
}

//Function for saving full receipt Data
//Takes name of receipt and an item struct array as inputs
func SaveAllReceiptData (NameOfReceipt: String, Items: Item) {
    
    //context variable for fetching and storing data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates Receipt Entity Context
    let ReceiptName = Receipt(context: context)
    ReceiptName.receiptName = NameOfReceipt
    
    //Create NSOrderedSet object (array) of all items
    //let allReceiptItems = NSOrderedSet(array: Items)
    let itemsInReceipt = ReceiptItems(context: context)
    itemsInReceipt.itemName = Items.itemName
    ReceiptName.addToItemsOnReceipt(itemsInReceipt)
    

    //save to container/core data
    do {
        try context.save()
    } catch {
        print(error)
    }
}


//Function that will delete the specified receipt (It will also delete item data)
func DeleteReceiptData (NameOfItem: String) {
    
    //delete specific data
    guard let item = Receipt.FetchData(with: NameOfItem) else { return }
    item.deleteReceipt()
}


//DELETE LATER: Function used to dismiss keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}