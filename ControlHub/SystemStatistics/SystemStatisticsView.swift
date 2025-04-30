import SwiftUI

struct SystemStatisticsView: View {
    @State private var systemStats: [String: String] = [:]
    @State private var timer: Timer?
    
    let systemStatsHandler = SystemStatistics()

    var body: some View {
        VStack {
            Text("System Statistics")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(systemStats.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                        .font(.subheadline)
                    Spacer()
                    Text(systemStats[key] ?? "Loading...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .onAppear {
            updateSystemStats()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // Update the stats every 2 seconds
    func updateSystemStats() {
        systemStats = systemStatsHandler.getSystemStats()
    }
    
    // Start a timer to periodically update system stats
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            updateSystemStats()
        }
    }
    
    // Stop the timer when the view is gone
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct SystemStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        SystemStatisticsView()
    }
}
