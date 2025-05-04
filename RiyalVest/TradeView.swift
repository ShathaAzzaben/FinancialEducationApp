import SwiftUI
import WebKit // استيراد WebKit لاستخدام WKWebView
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}



struct TradeView: View {
    var stock: Stock
    @State private var quantity: Int = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var balance: Double
    @State private var ownedStocks: [String: Int] = UserDefaults.standard.dictionary(forKey: "ownedStocks") as? [String: Int] ?? [:]
    @State private var soldStocks: [String: Int] = UserDefaults.standard.dictionary(forKey: "soldStocks") as? [String: Int] ?? [:]
    
    var body: some View {
        ZStack {
            // خلفية متدرّجة من اللون الأزرق الداكن (#05216F) إلى الأسود
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 5/255, green: 33/255, blue: 111/255),
                    .black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all) // تجاهل مناطق الآمن (Safe Area)
            
            ScrollView {
                VStack(spacing: 20) {
                    // TradingView Mini Chart Widget
                    TradingViewMiniChart(symbol: stock.symbol)
                        .frame(height: 300) // ارتفاع الرسم البياني
                        .cornerRadius(10)
                        .padding(.horizontal)
                      
                    
                    Text(stock.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                        .foregroundColor(.white) // تغيير لون النص إلى الأبيض
                    
                    Text("Current Price: \(stock.price)")
                        .font(.headline)
                        .foregroundColor(.white) // تغيير لون النص إلى الأبيض
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if quantity > 0 {
                                quantity -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(quantity)")
                            .font(.title)
                            .frame(width: 50, alignment: .center)
                            .foregroundColor(.white) // تغيير لون النص إلى الأبيض
                        
                        Button(action: {
                            quantity += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    Text("Owned: \(ownedStocks[stock.symbol, default: 0]) shares")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 20) {
                        Button("Buy") {
                            if quantity > 0 {
                                let totalCost = Double(quantity) * (Double(stock.price) ?? 0)
                                if balance >= totalCost {
                                    balance -= totalCost
                                    ownedStocks[stock.symbol, default: 0] += quantity
                                    alertMessage = "You bought \(quantity) shares of \(stock.symbol) at \(stock.price) each. Total cost: \(String(format: "%.2f", totalCost)) Riyal."
                                    
                                    // حفظ البيانات المحدثة
                                    UserDefaults.standard.set(balance, forKey: "balance")
                                    UserDefaults.standard.set(ownedStocks, forKey: "ownedStocks")
                                } else {
                                    alertMessage = "Insufficient balance to buy \(quantity) shares of \(stock.symbol)."
                                }
                            } else {
                                alertMessage = "Please select a valid quantity."
                            }
                            showAlert = true
                        }
                        .frame(width: 120, height: 50)
                        .background(Color.white)
                        .foregroundColor((Color(hex: "#05216f")))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .semibold))
                        
                        Button("Sell") {
                            if quantity > 0 {
                                let ownedQuantity = ownedStocks[stock.symbol, default: 0]
                                if ownedQuantity >= quantity {
                                    let totalEarnings = Double(quantity) * (Double(stock.price) ?? 0)
                                    balance += totalEarnings
                                    ownedStocks[stock.symbol] = ownedQuantity - quantity
                                    
                                    // تحديث الأسهم المباعة
                                    soldStocks[stock.symbol, default: 0] += quantity
                                    
                                    // إذا تم بيع كل الأسهم، قم بإزالة السهم من ownedStocks
                                    if ownedStocks[stock.symbol] == 0 {
                                        ownedStocks.removeValue(forKey: stock.symbol)
                                    }
                                    
                                    alertMessage = "You sold \(quantity) shares of \(stock.symbol) at \(stock.price) each. Total earnings: \(String(format: "%.2f", totalEarnings)) Riyal."
                                    
                                    // حفظ البيانات المحدثة
                                    UserDefaults.standard.set(balance, forKey: "balance")
                                    UserDefaults.standard.set(ownedStocks, forKey: "ownedStocks")
                                    UserDefaults.standard.set(soldStocks, forKey: "soldStocks")
                                } else {
                                    alertMessage = "You don't have enough shares of \(stock.symbol) to sell."
                                }
                            } else {
                                alertMessage = "Please select a valid quantity."
                            }
                            showAlert = true
                        }
                        .frame(width: 120, height: 50)
                        .background(Color.white)
                        .foregroundColor((Color(hex: "#05216f")))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .semibold))
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward.circle.fill")
                .foregroundColor(.white)
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Trade Result"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("successfully") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}

//الشارت

import SwiftUI
import WebKit

struct TradingViewMiniChart: UIViewRepresentable {
    var symbol: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        // HTML code for TradingView Mini Chart Widget
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
        </head>
        <body>
        <!-- TradingView Widget BEGIN -->
        <div class="tradingview-widget-container">
          <div class="tradingview-widget-container__widget"></div>
          <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
          <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-mini-symbol-overview.js" async>
          {
          "symbol": "\(symbol)",
          "width": "100%",
          "height": "300",
          "locale": "en",
          "dateRange": "12M",
          "colorTheme": "dark",
          "isTransparent": false,
          "autosize": true,
          "largeChartUrl": false,
          "chartOnly": true
        }
          </script>
        </div>
        <!-- TradingView Widget END -->
        </body>
        </html>
        """
        
        // Load HTML string into WebView
        webView.loadHTMLString(htmlString, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to update the WebView
    }
}
