import Foundation
import StoreKit

//@MainActor
//class PurchaseManager: ObservableObject {
//    
////    private let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]
//    
//    private let productIds = [SupportAppView.Tip.protector.productId,
//                              SupportAppView.Tip.ten.productId ]
//    
//    @Published
//    private(set) var products: [Product] = []
//    private var productsLoaded = false
//    
//    func loadProducts() async throws {
//        guard !self.productsLoaded else { return }
//        self.products = try await Product.products(for: productIds)
//        self.productsLoaded = true
//    }
//    
//    func purchase(_ product: Product) async throws {
//        let result = try await product.purchase()
//        
//        switch result {
//            case let .success(.verified(transaction)):
//                // Successful purhcase
//                await transaction.finish()
//            case let .success(.unverified(_, error)):
//                // Successful purchase but transaction/receipt can't be verified
//                // Could be a jailbroken phone
//                break
//            case .pending:
//                // Transaction waiting on SCA (Strong Customer Authentication) or
//                // approval from Ask to Buy
//                break
//            case .userCancelled:
//                // ^^^
//                break
//            @unknown default:
//                break
//        }
//    }
//}
