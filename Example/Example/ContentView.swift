//
//  ContentView.swift
//  Example
//
//  Created by wong on 8/19/25.
//

import SwiftUI
import OUIData

struct ContentView: View {
    @State private var ouiEntries: [String: String] = [:]
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading OUI Data...")
            } else if let error = errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                        .font(.largeTitle)
                    Text("Error: \(error)")
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else {
                List {
                    ForEach(ouiEntries.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        VStack(alignment: .leading) {
                            Text("OUI: \(key)")
                                .font(.headline)
                            Text(value)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("OUI Data")
        .onAppear {
            loadOUIData()
        }
    }
    
    private func loadOUIData() {
        Task {
            do {
                let data = try OUIData.fetchData()
                await MainActor.run {
                    self.ouiEntries = data
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
