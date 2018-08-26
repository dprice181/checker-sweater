//
//  IAPHandler.swift
//
import UIKit
import StoreKit
import SpriteKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}


class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var param1 : Int = 0
    var param2 : String = ""
    var param3 : SKNode = SKNode()
    var callbackFunc : ((Int,String,SKNode)->())? = nil
    
    let sectionIndDict = ["ScholarKidsAllSubjectsUnlock" : 0,"ScholarKidsMathUnlock":7,"ScholarKidsGrammarUnlock":9,
                          "ScholarKidsVocabularyUnlock":11,"ScholarKidsSpellingUnlock":13]
    
    let productIDByIndex = ["ScholarKidsAllSubjectsUnlock","ScholarKidsMathUnlock","ScholarKidsGrammarUnlock",
    "ScholarKidsVocabularyUnlock","ScholarKidsSpellingUnlock"]
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int,p1 : Int, p2 : String, p3 : SKNode,completion: @escaping (Int,String,SKNode)->()){
        if iapProducts.count == 0 { return }
        
        param1 = p1
        param2 = p2
        param3 = p3
        callbackFunc = completion
        if self.canMakePurchases() {
            if index < iapProducts.count {
                let id = productIDByIndex[index]
                var actualInd = 0
                for prod in iapProducts {
                    if prod.productIdentifier == id {
                        break
                    }
                    actualInd = actualInd + 1
                }
                let product = iapProducts[actualInd]
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
                
                print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
                productID = product.productIdentifier
            }
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProducts(){
        let productIdentifiers = NSSet(objects: "ScholarKidsAllSubjectsUnlock","ScholarKidsMathUnlock","ScholarKidsGrammarUnlock",
                                       "ScholarKidsVocabularyUnlock","ScholarKidsSpellingUnlock")
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {        
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                //let price1Str = numberFormatter.string(from: product.price)
                //print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    func UpdateMyOptions(payment: SKPayment) {
        if let sectionInd = sectionIndDict[payment.productIdentifier] {
            if sectionInd == 0 {
                global.optionAr[7] = "1"  //Math
                global.optionAr[9] = "1"
                global.optionAr[11] = "1"
                global.optionAr[13] = "1" //Spelling
            }
            else {
                global.optionAr[sectionInd] = "1"
            }
            UpdateOptions()
            WriteOptionsToFile()
            
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                let payment = trans.payment
                print ("payment id=",payment.productIdentifier)
                print ("transstate=",trans.transactionState)
                print("name=",global.currentStudent)
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    print ("xpayment id=",payment.productIdentifier)
                    if let funccall = callbackFunc {
                        funccall(param1,param2,param3)
                    }
                    UpdateMyOptions(payment:payment)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    purchaseStatusBlock?(.purchased)
                    break
                case .failed:
                    print("failed")
                    print ("xxpayment id=",payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    print("restored")
                    print ("xxxpayment id=",payment.productIdentifier)
                    if let funccall = callbackFunc {
                        funccall(param1,param2,param3)
                    }
                    UpdateMyOptions(payment:payment)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                default: break
                }
            }
        }
    }
}
