// SwimMate/iOSViews/SwimViews/SetView/SearchSheetView.swift

import SwiftUI

struct SearchSheetView: View
{
    @EnvironmentObject var manager: Manager
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    var body: some View
    {
        NavigationView
        {
            VStack
            {
                // Search Bar
                HStack
                {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)

                    TextField("Search sets...", text: $searchText)
                        .focused($isSearchFocused)
                        .submitLabel(.search)
                        .onSubmit
                        {
                            performSearch()
                        }

                    if !searchText.isEmpty
                    {
                        Button(action:
                            {
                                searchText = ""
                            })
                        {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding()

                // Recent searches or suggestions could go here
                if searchText.isEmpty
                {
                    VStack
                    {
                        Text("Search Tips")
                            .font(.headline)
                            .padding(.top)

                        VStack(alignment: .leading, spacing: 8)
                        {
                            Text("• Search by set name")
                            Text("• Search by stroke type")
                            Text("• Search by description")
                            Text("• Try terms like 'sprint', 'endurance', 'technique'")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                    }

                    Spacer()
                }
                else
                {
                    // Live search results could be shown here
                    Text("Press 'Apply' to search")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()

                    Spacer()
                }
            }
            .navigationTitle("Search Sets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItem(placement: .navigationBarLeading)
                {
                    Button("Cancel")
                    {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button("Apply")
                    {
                        performSearch()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear
            {
                searchText = manager.activeFilters.searchText
                isSearchFocused = true
            }
        }
    }

    private func performSearch()
    {
        manager.updateSearchText(searchText)
    }
}

#Preview
{
    SearchSheetView()
        .environmentObject(Manager())
}
