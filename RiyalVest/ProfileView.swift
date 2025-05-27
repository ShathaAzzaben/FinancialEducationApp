import SwiftUI
import Charts
import Intents
import IntentsUI
// S8: Track Real-Time Stock Market Data and My Virtual Balance
struct ProfileView: View {
    var userName: String
    
    @State private var initialBalance: Double = 50000 // الرصيد الابتدائي
    @State private var currentBalance: Double = UserDefaults(suiteName: "group.raghad.RiyalVest")?.double(forKey: "balance") ?? 50000 // الرصيد الحالي
    
    // تحميل الأسهم المملوكة من UserDefaults
    @State private var ownedStocks: [String: Int] =
        UserDefaults.standard.dictionary(forKey: "ownedStocks") as? [String: Int] ?? [:]
    // Load sold stocks from UserDefaults
    @State private var soldStocks: [String: Int] = UserDefaults.standard.dictionary(forKey: "soldStocks") as? [String: Int] ?? [:]
    
    // الربح (الربح لا يكون سالبًا)
    var profit: Double {
        let value = currentBalance - initialBalance
        return value > 0 ? value : 0
    }
    
    // الخسارة (الخسارة لا تكون سلبية)
    var loss: Double {
        let value = initialBalance - currentBalance
        return value > 0 ? value : 0
    }
    
    // إضافة Environment للوصول إلى presentationMode
    @Environment(\.presentationMode) var presentationMode
    
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
            .edgesIgnoringSafeArea(.all)
            // S9: View My Portfolio Performance
            ScrollView {
                VStack(spacing: 20) {
                    // عنوان الملف الشخصي
                    Text("\(userName)'s Wallet")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // القسم العلوي: بطاقة المحفظة + مخطط دائري للأسهم
                    HStack(spacing: 16) {
                        // بطاقة المحفظة
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Current Amount")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // الرصيد الحالي
                            HStack {
                                HStack(spacing: 3) {
                                    Image("Riyal")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Text("\(String(format: "%.2f", currentBalance))")
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            }
                            
                            // الربح (The profits)
                            HStack {
                                Text("Profits:")
                                    .foregroundColor(.green)
                                
                                let profitValue = profit > 0 ? "+\(String(format: "%.2f", profit))" : "+0.00"
                                Text(profitValue)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                            
                            // الخسارة (The losses)
                            HStack {
                                Text("Losses:")
                                    .foregroundColor(.red)
                                
                                let lossValue = loss > 0 ? "-\(String(format: "%.2f", loss))" : "-0.00"
                                Text(lossValue)
                                    .bold()
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                        
                        // المخطط الدائري (Pie Chart) للأسهم المملوكة
                        OwnedStocksPieChartView(ownedStocks: ownedStocks)
                    }
                    .padding(.horizontal)
                    
                    // قسم الأسهم المملوكة
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Owned Stocks")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        if ownedStocks.isEmpty {
                            Text("You don't own any stocks yet.")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        } else {
                            ForEach(Array(ownedStocks.keys), id: \.self) { symbol in
                                StockRow(symbol: symbol, shares: ownedStocks[symbol] ?? 0, isSold: false)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    // Sold Stocks Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Sold Stocks")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        if soldStocks.isEmpty {
                            Text("You haven't sold any stocks yet.")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        } else {
                            ForEach(Array(soldStocks.keys), id: \.self) { symbol in
                                StockRow(symbol: symbol, shares: soldStocks[symbol] ?? 0, isSold: true)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            // إذا لم يتم حفظ أي قيمة للرصيد في UserDefaults، اجعل الرصيد 50000
            if UserDefaults.standard.object(forKey: "balance") == nil {
                currentBalance = 50000
                UserDefaults.standard.set(50000, forKey: "balance")
            } else {
                // تحديث الرصيد والأسهم عند ظهور الشاشة
                currentBalance = UserDefaults.standard.double(forKey: "balance")
            }
            ownedStocks = UserDefaults.standard.dictionary(forKey: "ownedStocks") as? [String: Int] ?? [:]
            
            // حفظ الرصيد والربح والخسارة في UserDefaults المشترك
            if let sharedDefaults = UserDefaults(suiteName: "group.raghad.RiyalVest") {
                sharedDefaults.set(currentBalance, forKey: "balance")
                sharedDefaults.set(profit, forKey: "profit")
                sharedDefaults.set(loss, forKey: "loss")
                
                // طباعة البيانات للتأكد (اختياري)
                print("Data saved to shared UserDefaults: Balance = \(currentBalance), Profit = \(profit), Loss = \(loss)")
            } else {
                print("Failed to access shared UserDefaults")
            }
        }
        // تغيير زر العودة هنا
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward.circle.fill") // استخدام أي صورة من مكتبة SF Symbols
                .foregroundColor(.white) // لون الصورة
        })
    }
}

struct OwnedStocksPieChartView: View {
    let ownedStocks: [String: Int]
    
    // حساب مجموع الأسهم المملوكة
    var totalShares: Int {
        ownedStocks.values.reduce(0, +)
    }
    
    // مجموعة ألوان مخصصة
    let customColors: [Color] = [.red, .green, .blue, .orange, .purple, .pink, .yellow, .cyan, .mint, .indigo]
    
    var body: some View {
        // إذا لا توجد أسهم مملوكة، يظهر نص
        if totalShares == 0 {
            Text("No Owned Stocks")
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
        } else {
            // تحويل البيانات إلى مصفوفة قابلة للعرض
            let data = ownedStocks.map { (symbol: $0.key, shares: $0.value) }
            
            VStack(spacing: 20) {
                // المخطط الدائري
                Chart {
                    ForEach(Array(data.enumerated()), id: \.element.symbol) { index, item in
                        SectorMark(
                            angle: .value("Shares", Double(item.shares)),
                            innerRadius: .ratio(0.5) // لجعل الشكل دائري (Doughnut)
                        )
                        .foregroundStyle(customColors[index % customColors.count]) // استخدام الألوان المخصصة
                    }
                }
                .chartLegend(.hidden) // إخفاء التوضيحات التلقائية
                .frame(width: 100, height: 100)
                
                // قائمة الرموز والألوان (Legends) - بشكل أفقي
                VStack(spacing: 2) {
                    ForEach(Array(data.enumerated()), id: \.element.symbol) { index, item in
                        HStack(spacing: 3) {
                            Circle()
                                .fill(customColors[index % customColors.count]) // استخدام نفس الألوان المخصصة
                                .frame(width: 5, height: 5) // تصغير حجم الدائرة
                            
                            Text(item.symbol)
                                .font(.caption2) // استخدام حجم خط أصغر
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - تمديد Color لإنشاء ألوان فريدة بناءً على رمز السهم
extension Color {
    static func bySymbol(_ symbol: String) -> Color {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink, .yellow, .cyan, .mint, .indigo]
        let index = abs(symbol.hashValue) % colors.count
        return colors[index]
    }
}

// MARK: - صف لكل سهم
struct StockRow: View {
    var symbol: String
    var shares: Int
    var isSold: Bool // ما زالت الخاصية موجودة في حال أردت استخدامها لاحقًا
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(symbol)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(shares) shares")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // لاحقًا إذا أردت تمييز الأسهم المباعة، يمكنك استخدام isSold هنا
                if isSold {
                    Text("Sold")
                        .font(.subheadline)
                        .foregroundColor(.red)
                } else {
                    Text("Owned")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
    }
}
