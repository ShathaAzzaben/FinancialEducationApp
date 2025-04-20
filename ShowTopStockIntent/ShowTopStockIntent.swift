import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let topStocks: [Stock]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), topStocks: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let sampleStocks = [
            Stock(symbol: "AAPL", price: "150.00", change: "+2.00", changePercent: "+1.35%", name: "Apple Inc."),
            Stock(symbol: "MSFT", price: "300.00", change: "+1.50", changePercent: "+0.50%", name: "Microsoft Corp.")
        ]
        completion(SimpleEntry(date: Date(), topStocks: sampleStocks))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: "group.raghad.RiyalVest")
        var topStocks: [Stock] = []

        if let savedData = sharedDefaults?.data(forKey: "topStocks"),
           let decodedStocks = try? JSONDecoder().decode([Stock].self, from: savedData) {
            topStocks = decodedStocks
        }

        let entry = SimpleEntry(date: Date(), topStocks: topStocks)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct StockWidgetEntryView: View {
    var entry: Provider.Entry
    
    // الخلفية المتدرجة
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 5/255, green: 33/255, blue: 111/255),
                Color.black
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                if entry.topStocks.isEmpty {
                    Text("No stock data available")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(entry.topStocks.prefix(3)) { stock in
                        HStack {
                            Text(stock.symbol)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 51, alignment: .leading)
// منع التقسيم إلى سطرين
                                        .lineLimit(1) // التأكد من أن النص يظهر في سطر واحد
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(stock.price)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text(stock.changePercent)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(stock.changePercent.contains("-") ? .red : .green)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .containerBackground(for: .widget) { // أضف هذا السطر
            backgroundGradient
        }
    }
}


@main
struct StockWidget: Widget {
    let kind: String = "StockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StockWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Stocks")
        .description("Shows top 5 stocks")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


#Preview("Small Widget", as: .systemSmall) {
    StockWidget()
} timeline: {
    let mockStocks = [
        Stock(symbol: "AAPL", price: "150.00", change: "+2.00", changePercent: "+1.35%", name: "Apple Inc."),
        Stock(symbol: "MSFT", price: "300.00", change: "+1.50", changePercent: "+0.50%", name: "Microsoft Corp."),
        Stock(symbol: "GOOGL", price: "2800.00", change: "-5.00", changePercent: "-0.18%", name: "Alphabet Inc.")
    ]
    
    SimpleEntry(date: Date(), topStocks: mockStocks)
}
