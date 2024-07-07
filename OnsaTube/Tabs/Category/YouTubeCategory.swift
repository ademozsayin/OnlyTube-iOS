import Foundation
import Models

extension YouTubeCategory {
    func toDraft() -> Draft {
        return Draft(content: name)
    }
}

enum YouTubeCategory: Equatable, Hashable {
    case category(name: String, subcategories: [YouTubeCategory])
    
    var name: String {
        switch self {
            case .category(let name, _):
                return name
        }
    }
    
    var subcategories: [YouTubeCategory] {
        switch self {
            case .category(_, let subcategories):
                return subcategories
        }
    }
    
    static func == (lhs: YouTubeCategory, rhs: YouTubeCategory) -> Bool {
        switch (lhs, rhs) {
            case (.category(let lhsName, let lhsSubcategories), .category(let rhsName, let rhsSubcategories)):
                return lhsName == rhsName && lhsSubcategories == rhsSubcategories
        }
    }
    
    // Custom hash function for hashing
    func hash(into hasher: inout Hasher) {
        switch self {
            case .category(let name, _):
                hasher.combine(name)
        }
    }
    
    
    // Example categories and subcategories
    public static let allCategories: [YouTubeCategory] = [
        .category(name: "Music", subcategories: [
            .category(name: "Pop", subcategories: []),
            .category(name: "Rock", subcategories: []),
            .category(name: "Hip-Hop", subcategories: []),
            .category(name: "Classical", subcategories: []),
            .category(name: "Jazz", subcategories: [])
        ]),
        .category(name: "Gaming", subcategories: [
            .category(name: "Action", subcategories: []),
            .category(name: "Adventure", subcategories: []),
            .category(name: "Strategy", subcategories: []),
            .category(name: "Role-Playing", subcategories: []),
            .category(name: "Simulation", subcategories: [])
        ]),
        .category(name: "Education", subcategories: [
            .category(name: "Mathematics", subcategories: []),
            .category(name: "Science", subcategories: []),
            .category(name: "History", subcategories: []),
            .category(name: "Languages", subcategories: []),
            .category(name: "Technology", subcategories: [])
        ]),
        .category(name: "Entertainment", subcategories: [
            .category(name: "Movies", subcategories: []),
            .category(name: "TV Shows", subcategories: []),
            .category(name: "Talk Shows", subcategories: []),
            .category(name: "Celebrity News", subcategories: []),
            .category(name: "Music Videos", subcategories: [])
        ]),
        .category(name: "News & Politics", subcategories: [
            .category(name: "World News", subcategories: []),
            .category(name: "Local News", subcategories: []),
            .category(name: "Politics", subcategories: []),
            .category(name: "Economics", subcategories: []),
            .category(name: "Investigative Journalism", subcategories: [])
        ]),
        .category(name: "Sports", subcategories: [
            .category(name: "Football", subcategories: []),
            .category(name: "Basketball", subcategories: []),
            .category(name: "Tennis", subcategories: []),
            .category(name: "Cricket", subcategories: []),
            .category(name: "Golf", subcategories: [])
        ]),
        .category(name: "Technology", subcategories: [
            .category(name: "Gadgets", subcategories: []),
            .category(name: "Reviews", subcategories: []),
            .category(name: "Tech News", subcategories: []),
            .category(name: "Programming", subcategories: []),
            .category(name: "Science & Tech", subcategories: [])
        ]),
        .category(name: "Science", subcategories: [
            .category(name: "Physics", subcategories: []),
            .category(name: "Biology", subcategories: []),
            .category(name: "Chemistry", subcategories: []),
            .category(name: "Astronomy", subcategories: []),
            .category(name: "Environmental Science", subcategories: [])
        ]),
        .category(name: "Travel", subcategories: [
            .category(name: "Destinations", subcategories: []),
            .category(name: "Travel Vlogs", subcategories: []),
            .category(name: "Travel Tips", subcategories: []),
            .category(name: "Cultural Insights", subcategories: []),
            .category(name: "Food & Travel", subcategories: [])
        ]),
        .category(name: "Food", subcategories: [
            .category(name: "Recipes", subcategories: []),
            .category(name: "Cooking Techniques", subcategories: []),
            .category(name: "Restaurant Reviews", subcategories: []),
            .category(name: "Food Challenges", subcategories: []),
            .category(name: "Baking", subcategories: [])
        ]),
        .category(name: "DIY & How-To", subcategories: [
            .category(name: "Home Improvement", subcategories: []),
            .category(name: "Crafts", subcategories: []),
            .category(name: "Gardening", subcategories: []),
            .category(name: "Technology Projects", subcategories: []),
            .category(name: "Repairs", subcategories: [])
        ]),
        .category(name: "Fitness", subcategories: [
            .category(name: "Workout Routines", subcategories: []),
            .category(name: "Nutrition", subcategories: []),
            .category(name: "Yoga", subcategories: []),
            .category(name: "Pilates", subcategories: []),
            .category(name: "Home Workouts", subcategories: [])
        ]),
        .category(name: "Lifestyle", subcategories: [
            .category(name: "Home Decor", subcategories: []),
            .category(name: "Fashion", subcategories: []),
            .category(name: "Beauty", subcategories: []),
            .category(name: "Personal Development", subcategories: []),
            .category(name: "Daily Vlogs", subcategories: [])
        ]),
        .category(name: "Comedy", subcategories: [
            .category(name: "Stand-Up", subcategories: []),
            .category(name: "Sketches", subcategories: []),
            .category(name: "Parodies", subcategories: []),
            .category(name: "Improv", subcategories: []),
            .category(name: "Funny Moments", subcategories: [])
        ]),
        .category(name: "Vlogs", subcategories: [
            .category(name: "Daily Vlogs", subcategories: []),
            .category(name: "Travel Vlogs", subcategories: []),
            .category(name: "Family Vlogs", subcategories: []),
            .category(name: "Personal Vlogs", subcategories: []),
            .category(name: "Lifestyle Vlogs", subcategories: [])
        ]),
        .category(name: "Reviews", subcategories: [
            .category(name: "Product Reviews", subcategories: []),
            .category(name: "Tech Reviews", subcategories: []),
            .category(name: "Book Reviews", subcategories: []),
            .category(name: "Movie Reviews", subcategories: []),
            .category(name: "Food Reviews", subcategories: [])
        ]),
        .category(name: "Health", subcategories: [
            .category(name: "Mental Health", subcategories: []),
            .category(name: "Fitness & Exercise", subcategories: []),
            .category(name: "Nutrition", subcategories: []),
            .category(name: "Medical Advice", subcategories: []),
            .category(name: "Wellness", subcategories: [])
        ]),
        .category(name: "Pets & Animals", subcategories: [
            .category(name: "Pet Care", subcategories: []),
            .category(name: "Animal Behavior", subcategories: []),
            .category(name: "Wildlife", subcategories: []),
            .category(name: "Pet Vlogs", subcategories: []),
            .category(name: "Funny Animal Videos", subcategories: [])
        ]),
        .category(name: "Art & Design", subcategories: [
            .category(name: "Drawing Tutorials", subcategories: []),
            .category(name: "Painting Techniques", subcategories: []),
            .category(name: "Graphic Design", subcategories: []),
            .category(name: "Crafts", subcategories: []),
            .category(name: "Art History", subcategories: [])
        ]),
        .category(name: "Business", subcategories: [
            .category(name: "Entrepreneurship", subcategories: []),
            .category(name: "Marketing", subcategories: []),
            .category(name: "Finance", subcategories: []),
            .category(name: "Startups", subcategories: []),
            .category(name: "Leadership", subcategories: [])
        ]),
        .category(name: "Finance", subcategories: [
            .category(name: "Investing", subcategories: []),
            .category(name: "Personal Finance", subcategories: []),
            .category(name: "Economics", subcategories: []),
            .category(name: "Financial Planning", subcategories: []),
            .category(name: "Cryptocurrency", subcategories: [])
        ]),
        .category(name: "Documentary", subcategories: [
            .category(name: "Historical", subcategories: []),
            .category(name: "Nature", subcategories: []),
            .category(name: "Social Issues", subcategories: []),
            .category(name: "Science", subcategories: []),
            .category(name: "True Crime", subcategories: [])
        ]),
        .category(name: "ASMR", subcategories: [
            .category(name: "Roleplay", subcategories: []),
            .category(name: "Tapping", subcategories: []),
            .category(name: "Whispering", subcategories: []),
            .category(name: "Crinkling", subcategories: []),
            .category(name: "Ambient Sounds", subcategories: [])
        ])
    ]
}

