import SwiftUI
struct NameInputView: View {
    @State private var userName = ""
    @State private var navigateToContentView = false
    @State private var balance: Double = 50000
    @State private var showSplash = true  // حالة لعرض شاشة السبلاش
// task s7 "Develop the Home Screen with a Welcome Message and Name Input"
    var body: some View {
        NavigationStack {
            ZStack {
                // الخلفية الكاملة: تمتد على كامل الشاشة
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 5/255, green: 33/255, blue: 111/255), // #05216F
                        .black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // المحتوى الأساسي: شاشة إدخال الاسم
                VStack {
                    Text("Enter your name")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    TextField("Enter your name", text: $userName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocapitalization(.words)
                    
                    NavigationLink(
                        destination: ContentView(userName: userName, balance: $balance),
                        isActive: $navigateToContentView
                    ) {
                        Button("Enter") {
                            if !userName.trimmingCharacters(in: .whitespaces).isEmpty {
                                // حفظ البيانات في UserDefaults
                                UserDefaults.standard.set(userName, forKey: "userName")
                                UserDefaults.standard.set(balance, forKey: "balance")
                                navigateToContentView = true
                            }
                        }
                        .padding()
                        .frame(width: 120, height: 50)
                        .background(userName.isEmpty ? Color.gray : Color.white)
                        .foregroundColor((Color(hex: "#05216f")))
                        .font(.system(size: 20, weight: .semibold))
                        .cornerRadius(10)
                        .padding(.horizontal)
//                        .disabled(userName.isEmpty)
                    }
                    .disabled(userName.isEmpty)
                }
                
                // شاشة السبلاش تظهر فوق المحتوى إذا كانت الحالة true
                if showSplash {
                    SplashScreen()
                        .transition(.opacity)
                }
            }
            .onAppear {
                // إخفاء السبلاش بعد 3 ثوانٍ مع تأثير انتقالي
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSplash = false
                    }
                }
                // تحميل البيانات المحفوظة عند فتح التطبيق
                if let savedUserName = UserDefaults.standard.string(forKey: "userName") {
                    userName = savedUserName
                    balance = UserDefaults.standard.double(forKey: "balance")
                    navigateToContentView = true
                }
            }
        }
    }
}
// task s6 start "Implement the Splash Screen with the Logo"
// شاشة السبلاش
struct SplashScreen: View {
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
            
            // صورة "Stock" في المنتصف (تأكّد من إضافتها إلى Assets)
            VStack(spacing: 30) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Invest Fearlessly, Learn Confidently!")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
        }
    }
}

#Preview {
    SplashScreen()
}

