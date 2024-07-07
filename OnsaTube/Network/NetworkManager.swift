//import Alamofire
//
//class NetworkManager {
//    static let shared = NetworkManager()
//    private let apiKey = "YOUR_OPENAI_API_KEY"
//    private let url = "https://api.openai.com/v1/engines/davinci-codex/completions"
//    
//    private init() {}
//    
//    func fetchMainCategories(completion: @escaping (String?) -> Void) {
//        let prompt = "Please list popular main categories such as sports, dinner, science, etc."
//        fetchChatGPTResponse(prompt: prompt, completion: completion)
//    }
//    
//    func fetchSubCategories(for mainCategory: String, completion: @escaping (String?) -> Void) {
//        let prompt = "Please list popular subcategories for \(mainCategory)."
//        fetchChatGPTResponse(prompt: prompt, completion: completion)
//    }
//    
//    private func fetchChatGPTResponse(prompt: String, completion: @escaping (String?) -> Void) {
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(apiKey)",
//            "Content-Type": "application/json"
//        ]
//        
//        let parameters: [String: Any] = [
//            "prompt": prompt,
//            "max_tokens": 100
//        ]
//        
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            switch response.result {
//                case .success(let value):
//                    if let json = value as? [String: Any],
//                       let choices = json["choices"] as? [[String: Any]],
//                       let text = choices.first?["text"] as? String {
//                        completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
//                    } else {
//                        completion(nil)
//                    }
//                case .failure(let error):
//                    print("Error: \(error)")
//                    completion(nil)
//            }
//        }
//    }
//}
