//
//  ContentView.swift
//  Example
//
//  Created by wong on 8/19/25.
//

import SwiftUI
import OUIData

struct ContentView: View {
    @State private var ouiEntries: [OUIEntry] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
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
                        ForEach(ouiEntries, id: \.id) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.id)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(entry.companyInfo)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("OUI Data")
            .onAppear {
                loadOUIData()
            }
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
