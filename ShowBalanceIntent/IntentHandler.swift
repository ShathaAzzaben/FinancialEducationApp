//import Intents
//
//class IntentHandler: INExtension {
//    
//    override func handler(for intent: INIntent) -> Any {
//        // This is the default implementation.  If you want different objects to handle different intents,
//        // you can override this and return the handler you want for that particular intent.
//        
//        guard intent is ShowBalanceIntent else {
//           
//            fatalError("Unhandled Intent tent Error : \(intent) ")
//            
//        }
//        return self
//    }
//    
//}
//
//
//class ShowBalanceIntentHandler: NSObject, ShowBalanceIntentHandling {
//    func resolveUserName(for intent: ShowBalanceIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
//        <#code#>
//    }
//    
////    func resolveUserName(for intent: ShowBalanceIntent) async -> INStringResolutionResult {
////        <#code#>
////    }
//    
//    func handle(intent: ShowBalanceIntent, completion: @escaping (ShowBalanceIntentResponse) -> Void) {
//        // جلب الرصيد الحالي من UserDefaults
//        let currentBalance = UserDefaults.standard.double(forKey: "balance")
//        
//        // إنشاء رد ناجح مع الرصيد الحالي
//        let response = ShowBalanceIntentResponse.success(balance: "\(currentBalance)")
//        completion(response)
//    }
//}


//class ShowBalanceIntentHandler: NSObject, ShowBalanceIntentHandling {
//    func handle(intent: ShowBalanceIntent, completion: @escaping (ShowBalanceIntentResponse) -> Void) {
//        // جلب الرصيد الحالي من UserDefaults
//        if let currentBalance = UserDefaults.standard.object(forKey: "balance") as? Double {
//            // إنشاء رد ناجح مع الرصيد الحالي
//            let response = ShowBalanceIntentResponse.success(balance: "\(currentBalance)")
//            completion(response)
//        } else {
//            // إنشاء رد فاشل
//            let response = ShowBalanceIntentResponse.failure(error: "Unable to retrieve balance.")
//            completion(response)
//        }
//    }
//}

//import Intents
//
//class IntentHandler: INExtension {
//    override func handler(for intent: INIntent) -> Any {
//        if intent is ShowBalanceIntent {
//            return ShowBalanceIntentHandler()
//        }
//        fatalError("Unhandled Intent Error: \(intent)")
//    }
//}
//
//
////class ShowBalanceIntentHandler: NSObject, ShowBalanceIntentHandling {
////    func resolveUserName(for intent: ShowBalanceIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
////        if let userName = intent.userName {
////            completion(.success(with: userName))
////        } else {
////            completion(.needsValue())
////        }
////    }
//
//class ShowBalanceIntentHandler: NSObject, ShowBalanceIntentHandling {
////    func resolveUserName(for intent: ShowBalanceIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
////        <#code#>
////    }
//    
//    func handle(intent: ShowBalanceIntent, completion: @escaping (ShowBalanceIntentResponse) -> Void) {
//        // جلب الرصيد الحالي من UserDefaults
//        let currentBalance = UserDefaults.standard.double(forKey: "balance")
//        
//        // جلب الربح والخسارة من UserDefaults (إذا كنت تحفظها)
//        let profit = UserDefaults.standard.double(forKey: "profit")
//        let loss = UserDefaults.standard.double(forKey: "loss")
//        
////        // إذا لم تكن الربح والخسارة محفوظة، قم بحسابها
////        let initialBalance = 50000.0 // الرصيد الابتدائي
////        let calculatedProfit = max(currentBalance - initialBalance, 0)
////        let calculatedLoss = max(initialBalance - currentBalance, 0)
////        
////        // استخدام القيم المحفوظة أو المحسوبة
////        let finalProfit = (profit != 0) ? profit : calculatedProfit
////        let finalLoss = (loss != 0) ? loss : calculatedLoss
////        
//        // تحويل القيم إلى NSDecimalNumber (إذا كان الـ Intent يتطلب ذلك)
//        let balanceDecimal = NSDecimalNumber(value: currentBalance)
//        let profitDecimal = NSDecimalNumber(value: profit)
//        let lossDecimal = NSDecimalNumber(value: loss)
//        
//        // إنشاء رد ناجح مع الرصيد الحالي والربح والخسارة
//        let response = ShowBalanceIntentResponse.success(
//            balance: balanceDecimal,
//            profit: profitDecimal,
//            loss: lossDecimal
//        )
//        completion(response)
//    }
//}
    
//    func handle(intent: ShowBalanceIntent, completion: @escaping (ShowBalanceIntentResponse) -> Void) {
//        // جلب الرصيد الحالي من UserDefaults
//        let currentBalance = UserDefaults.standard.double(forKey: "balance")
//        
//        // إنشاء رد ناجح مع الرصيد الحالي
//        let response = ShowBalanceIntentResponse.success(balance: "\(currentBalance)")
//        completion(response)
//    }
    
//    func handle(intent: ShowBalanceIntent, completion: @escaping (ShowBalanceIntentResponse) -> Void) {
//        // جلب الرصيد الحالي من UserDefaults
//        let currentBalance = UserDefaults.standard.double(forKey: "balance")
//        
//        // حساب الربح والخسارة
//        let initialBalance = 50000.0 // الرصيد الابتدائي
//        let profit = max(currentBalance - initialBalance, 0)
//        let loss = max(initialBalance - currentBalance, 0)
//        
//        // تحويل القيم إلى NSDecimalNumber
//        let balanceDecimal = NSDecimalNumber(value: currentBalance)
//        let profitDecimal = NSDecimalNumber(value: profit)
//        let lossDecimal = NSDecimalNumber(value: loss)
//        
//        // إنشاء رد ناجح مع الرصيد الحالي والربح والخسارة
//        let response = ShowBalanceIntentResponse.success(balance: balanceDecimal, profit: profitDecimal, loss: lossDecimal)
//        completion(response)
//    }
//    
//    func handle(intent: ShowBalanceIntent, completion: @escaping (ShowBalanceIntentResponse) -> Void) {
//        // Fetch the current balance from UserDefaults
//        let currentBalance = UserDefaults.standard.double(forKey: "balance")
//        
//        // Calculate profit and loss
//        let initialBalance = 50000.0 // Initial balance
//        let profit = max(currentBalance - initialBalance, 0)
//        let loss = max(initialBalance - currentBalance, 0)
//        
//        // Create a readable response for Siri
//        let responseText = "Your current balance is \(String(format: "%.2f", currentBalance)), your profit is \(String(format: "%.2f", profit)), and your loss is \(String(format: "%.2f", loss))."
//        
//        // Create a success response with the text
//        let response = ShowBalanceIntentResponse.success(response: responseText)
//        completion(response)
//    }
    

