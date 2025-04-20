import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StockViewModel()
    var userName: String
    @Binding var balance: Double // تغيير balance إلى @Binding
    @State private var logoScale: CGFloat = 0.5 // بداية الحركة بحجم صغير
    @State private var showLogo = true
    var body: some View {
        NavigationStack {
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

                VStack(spacing: 0) { // إزالة التباعد بين العناصر
                    // إضافة نص "Stocks" في الجهة اليسرى
                    Text("Stocks")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading) // محاذاة النص لليسار
                        .padding(.leading, 20) // إضافة مسافة من الجهة اليسرى
                        .padding(.top, 20) // تقليل المسافة بين النص والـ List

                    List {
                        ForEach(viewModel.stocks) { stock in
                            // محتوى الخلية
                            ZStack {
                                // NavigationLink مخفي
                                NavigationLink(destination: TradeView(stock: stock, balance: $balance)) {
                                    EmptyView()
                                }
                                .opacity(0)

                                // محتوى المستطيل
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(stock.symbol)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white) // نص أبيض
                                        Text(stock.name)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8)) // نص أبيض شفاف
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text(stock.price)
                                            .foregroundColor(.white) // نص أبيض
                                        Text("\(stock.change) (\(stock.changePercent))")
                                            .foregroundColor(stock.change.contains("-") ? .red : .green)
                                    }
                             
                                    VStack(alignment: .leading) {
                                        Image(systemName: "arrowshape.right.fill")
                                            .foregroundColor(.white)
                                                                        }
                                }
                                .padding()
                                .background(Color.white.opacity(0.2)) // لون المستطيل الداخلي (أبيض شفاف)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)) // مسافة بين الخلايا
                            .listRowSeparator(.hidden) // إخفاء الخط الفاصل
                            .listRowBackground(Color.clear) // جعل خلفية الخلية شفافة
                        }
                    }
                    .background(Color.clear) // جعل خلفية الـ List شفافة
                    .scrollContentBackground(.hidden) // إخفاء الخلفية الافتراضية للـ List
                    .onAppear {
                        Task {
                            await viewModel.fetchStocks()
                        }
                    }
                    }
                
           
                
                // إضافة Overlay للوقو
                    if showLogo {
                        ZStack {
                            // خلفية شفافة
                            Color.black.opacity(0.7) // يمكنك تعديل قيمة الشفافية هنا
                                .edgesIgnoringSafeArea(.all)
                            
                            // صورة اللوقو
                            Image("Logo") // استبدل "logo" باسم الصورة الخاصة بك
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .scaleEffect(logoScale) // تطبيق الحركة على الحجم
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 2)) { // حركة تكبير
                                        logoScale = 1.2 // تكبير الصورة
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation(.easeInOut(duration: 1)) { // حركة تصغير
                                            logoScale = 0.5 // تصغير الصورة
                                        }
                                    }
                                    // إخفاء الصورة بعد 3 ثواني
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            showLogo = false
                                        }
                                    }
                                }
                        }
                    }
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        // صورة البروفايل
                        NavigationLink(destination: ProfileView(userName: userName)) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white) // أيقونة بيضاء
                        }
                        
                        // نص الترحيب
                        Text("Hi \(userName)")
                            .font(.headline)
                            .foregroundColor(.white) // نص أبيض
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Image("Riyal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(String(format: "%.2f", balance))
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
        }
    }


#Preview {
    ContentView(userName: "John Doe", balance: .constant(500000))
}
