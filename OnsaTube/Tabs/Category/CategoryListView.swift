import SwiftUI
import DesignSystem
import Models
import SwiftData

@MainActor
struct CategoryListView: View {
   
    @Binding var showCongratulation: Bool
    @Environment(Theme.self) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: YouTubeCategory? = nil
    @State private var selectedCategoryScale: CGFloat = 1.0
    @Binding var selectedItems: [YouTubeCategory] // Bind selected items

    @State private var selections: [String] = [] {
        didSet {
            print(selections)
        }
    }
    
    let startAgain: () -> Void
    let categories: [YouTubeCategory]
    let onSelection: (YouTubeCategory) -> Void
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Draft.creationDate, order: .reverse) var tagGroups: [Draft]

    @State var isSaving: Bool = false

    var body: some View {
        ScrollView {
            
            if showCongratulation {
                
                VStack(alignment: .leading) {
                    Text("Selected Items:")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                   
                    ForEach(selectedItems, id: \.self ) { item in
                        Text(subcategoryName(for: item))
                            .padding()
                            .background(theme.tintColor.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                        
                    }
                }
                .padding()
                
                CongratulationView()
                
                Button(action: {
                    startAgain()
                    // Reset the state here if needed
                    selectedItems.removeAll()
                    deleteAll()
                    
                }) {
                    Text("Start Again")
                        .padding()
                        .background(theme.tintColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
            } else {
                VStack(spacing: 16) {
                    ForEach(categories.indices, id: \.self) { index in
                        let category = categories[index]
                        VStack {
                            CategoryItemView(
                                categoryName: subcategoryName(for: category)
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .background(category == selectedCategory ? theme.tintColor : theme.secondaryBackgroundColor)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .scaleEffect(category == selectedCategory ? selectedCategoryScale : 1)
                        .onTapGesture {
                            handleSelection(category)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
            }
        }
        .background(theme.primaryBackgroundColor) 
        .navigationTitle(showCongratulation == false ? "Select a Category" : "Congratulations")
        .toolbar{
            toolbarContent
        }
        .withModelContainer()
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        CancelToolbarItem()
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                Task {
                    await save()
                    dismiss()
                }
            } label: {
                if isSaving {
                    ProgressView()
                } else {
                    Text("Save").bold()
                }
            }
            .disabled(selectedItems.isEmpty)
        }
    }
    
    private func save() async {
        isSaving = true
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        do {
            // Loop over selected items
            for item in selectedItems {
                // Convert each item to a draft
                let draft = item.toDraft()
                // Insert the draft into the context
                context.insert(draft)
            }
            
            // Save the context
            try context.save()
            
            isSaving = false
            print("Saved successfully")
        } catch {
            print("Failed to save items: \(error)")
            isSaving = false
        }
    }
    
    private func handleSelection(_ category: YouTubeCategory) {
        selectedCategory = category
    
        selectedItems.append(category) // Add to selected items

        withAnimation(.easeInOut(duration: 0.3)) {
            selectedCategoryScale = 1.1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedCategoryScale = 1.0
                if case .category(_, let subcategories) = category, subcategories.isEmpty {
                    showCongratulation = true
                    
                } else {
                    onSelection(category)
                }
            }
        }
    }
    
    private func deleteAll() {
        // Fetch all drafts and delete them
        let allDrafts = tagGroups
        for draft in allDrafts {
            context.delete(draft)
        }
        
        // Save changes
        do {
            try context.save()
            print("deleted safely")
        } catch {
            print("Failed to delete all items: \(error)")
        }
    }
    
    private func subcategoryName(for category: YouTubeCategory) -> String {
        switch category {
            case .category(let name, _):
                return name
        }
    }
}

// Preview
#Preview {
    CategorySelectionView()
}
struct CongratulationView: View {
    @Environment(Theme.self) private var theme

    
    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("You have successfully selected all relevant categories.")
                .font(.body)
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}

@MainActor
struct CategoryItemView: View {
    let categoryName: String
   
    @Environment(Theme.self) private var theme

    var body: some View {
        HStack {
            Text(categoryName)
                .font(.headline)
                .padding()
                .foregroundColor(theme.labelColor)
                .padding(.horizontal, 10)
        }
    }
}
