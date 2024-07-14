import DesignSystem
import Env
import Models
import SwiftData
import SwiftUI

@MainActor
struct CategorySelectionView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(Theme.self) private var theme
    
    enum ViewState {
        case loading
        case error(error: String)
        case result
    }
    
    @State private var state: ViewState = .loading
    @State private var currentCategories: [YouTubeCategory] = []
    @State private var showCongratulation: Bool = false
    @State private var selectedCategory: YouTubeCategory? = nil
    @State var selectedItems: [YouTubeCategory] = [] // Track selected items

    var body: some View {
        NavigationStack {
            VStack {
                switch state {
                    case .loading:
                        VStack {
                            LoadingView(customText: Localization.preparingText)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                        }
                    case .error(let error):
                        Text(error) // Display the error message
                    case .result:
                        
                        if let category = selectedCategory {
                            if case .category(_, let subcategories) = category {
                                
                                CategoryListView(showCongratulation: $showCongratulation,
                                                 selectedItems: $selectedItems,
                                                 startAgain: startAgain,
                                                 categories: subcategories,
                                                 onSelection: handleCategorySelection)
                                
                            } else {
                                Text("No subcategories available.")
                            }
                        } else {
                           CategoryListView(showCongratulation: $showCongratulation,
                                            selectedItems: $selectedItems, // Pass the binding
                                            startAgain: startAgain,
                                            categories: YouTubeCategory.allCategories,
                                            onSelection: handleCategorySelection)
                        }
                }
            }
            .navigationTitle(currentCategories.isEmpty ? Localization.selectCategory : Localization.subcategories)
            .navigationBarTitleDisplayMode(.inline)
            .background(theme.secondaryBackgroundColor)
            .scrollContentBackground(.hidden)
            .task {
                await delay(seconds: 0.83)
                state = .result
            }
        }
    }
    
    private func startAgain() {
        currentCategories = []
        showCongratulation = false
        selectedCategory = nil
        selectedItems.removeAll() //
    }
    
    private func handleCategorySelection(_ category: YouTubeCategory) {
        if case .category(_, let subcategories) = category, subcategories.isEmpty {
            showCongratulation = true
            selectedItems.append(category)
        } else {
            selectedCategory = category
            showCongratulation = false
        }
    }
    
    private func delay(seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

extension CategorySelectionView {
    enum Localization {
        static let preparingText = NSLocalizedString(
            "We are preparing choices for you...",
            comment: ""
        )
        
        static let selectCategory = NSLocalizedString(
            "Select a Category",
            comment: ""
        )
        
        static let subcategories = NSLocalizedString(
            "Subcategories",
            comment: ""
        )
      
    }
}
