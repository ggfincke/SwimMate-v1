// SwimMate/iOSViews/Components/Cards/DataExportSheet.swift

import SwiftUI

struct DataExportSheet: View
{
    @EnvironmentObject var manager: Manager
    @Environment(\.dismiss) private var dismiss

    var body: some View
    {
        NavigationView
        {
            VStack(spacing: 20)
            {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)

                Text("Export Workout Data")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Your data will be exported in CSV format including all workout details, dates, and performance metrics.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8)
                {
                    Text("Export includes:")
                        .font(.headline)

                    HStack
                    {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("\(manager.swims.count) workout sessions")
                    }

                    HStack
                    {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Distance and duration data")
                    }

                    HStack
                    {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Stroke and performance metrics")
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button("Export Data")
                {
                    exportData()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("Cancel")
                {
                    dismiss()
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }

    private func exportData()
    {
        // In a real app, this would generate and share a CSV file
        if manager.hapticFeedback
        {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
        dismiss()
    }
}

#Preview
{
    DataExportSheet()
        .environmentObject(Manager())
}