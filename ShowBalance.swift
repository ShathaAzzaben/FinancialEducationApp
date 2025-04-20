//
//  ShowBalance.swift
//  RiyalVest
//
//  Created by Raghad on 16/09/1446 AH.
//

import Foundation
import AppIntents
import Intents


@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ShowBalance: AppIntent, CustomIntentMigratedAppIntent, PredictableIntent {
    static let intentClassName = "ShowBalanceIntent"

    static var title: LocalizedStringResource = "Show Balance"
    static var description = IntentDescription("Show the current balance in RiyalVest")

    static var parameterSummary: some ParameterSummary {
        Summary("Show the current balance, profit, and loss")
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction {
            DisplayRepresentation(
                title: "Show Balance",
                subtitle: "Displays the current balance, profit, and loss"
            )
            
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        // جلب البيانات من UserDefaults المشترك
        if let sharedDefaults = UserDefaults(suiteName: "group.raghad.RiyalVest") {
            let currentBalance = sharedDefaults.double(forKey: "balance")
            let profit = sharedDefaults.double(forKey: "profit")
            let loss = sharedDefaults.double(forKey: "loss")
            
            // إنشاء نص يحتوي على الرصيد والربح والخسارة
            let responseText = "Your balance is \(String(format: "%.2f", currentBalance))، profit is \(String(format: "%.2f", profit))، and loss is \(String(format: "%.2f", loss))"
            
            // طباعة البيانات للتأكد (اختياري)
            print("Data retrieved from shared UserDefaults: Balance = \(currentBalance), Profit = \(profit), Loss = \(loss)")
            
            return .result(value: responseText)
        } else {
            throw NSError(domain: "com.raghad.RiyalVest", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to access shared UserDefaults"])
        }
    }
    

}
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
fileprivate extension IntentDialog {
    static func responseSuccess(balance: Double, profit: Double, loss: Double) -> Self {
        "Your balance is \(String(format: "%.2f", balance))، profit is \(String(format: "%.2f", profit))، and loss is \(String(format: "%.2f", loss))"
    }
    
    static func responseFailure() -> Self {
        "Sorry, I couldn't find your balance. Please try again later."
    }
}

//@available(iOS 16.0, *)
//struct ShowBalanceApp: AppIntent {
//    static var title: LocalizedStringResource = "Show Balance"
//    static var description = IntentDescription("Show the current balance in RiyalVest")
//
//    func perform() async throws -> some IntentResult & ReturnsValue<String> {
//        return .result(value: "Your balance is 100 Riyals")
//    }
//}
//
//

//@available(iOS 16.0, *)
//struct RiyalVestShortcuts: AppShortcutsProvider {
//    static var appShortcuts: [AppShortcut] {
//        return [
//            AppShortcut(
//                intent: ShowBalance(),
//                phrases: [
//                    "Show the current balance in RiyalVest",
//                    "كم عندي في RiyalVest؟"
//                ],
//                shortTitle: "Check Balance",
//                systemImageName: "dollarsign.circle"
//            )
//        ]
//    }بب
//}

//import Foundation
//import AppIntents
//
//@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
//struct ShowBalance: AppIntent, CustomIntentMigratedAppIntent, PredictableIntent {
//    static let intentClassName = "ShowBalanceIntent"
//
//    static var title: LocalizedStringResource = "Show Balance"
//    static var description = IntentDescription("Displays the current balance, profit, and loss of the user")
//
//    static var parameterSummary: some ParameterSummary {
//        Summary("Show the current balance, profit, and loss")
//    }
//
//    static var predictionConfiguration: some IntentPredictionConfiguration {
//        IntentPrediction {
//            DisplayRepresentation(
//                title: "Show Balance",
//                subtitle: "Displays the current balance, profit, and loss"
//            )
//        }
//    }
//
//    func perform() async throws -> some IntentResult & ReturnsValue<String> {
//        if let sharedDefaults = UserDefaults(suiteName: "group.raghad.RiyalVest") {
//            let currentBalance = sharedDefaults.double(forKey: "balance")
//            let profit = sharedDefaults.double(forKey: "profit")
//            let loss = sharedDefaults.double(forKey: "loss")
//            
//            let responseText = "Your balance is \(String(format: "%.2f", currentBalance))، profit is \(String(format: "%.2f", profit))، and loss is \(String(format: "%.2f", loss))"
//            
//            print("Data retrieved from shared UserDefaults: Balance = \(currentBalance), Profit = \(profit), Loss = \(loss)")
//            
//            return .result(value: responseText)
//        } else {
//            throw NSError(domain: "com.raghad.RiyalVest", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to access shared UserDefaults"])
//        }
//    }
//}
//
