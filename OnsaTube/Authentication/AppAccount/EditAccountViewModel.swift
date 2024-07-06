import Models
import Network
import Observation
import PhotosUI
import SwiftUI
import FirebaseAuth
import FirebaseStorage


@MainActor
@Observable class EditAccountViewModel {
    @Observable class FieldEditViewModel: Identifiable {
        let id = UUID().uuidString
        var name: String = ""
        var value: String = ""
        
        init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
    
        
    let authManager = AuthenticationManager.shared
    
    var displayName: String = ""
   
    var avatar: URL?
    
    var isPhotoPickerPresented: Bool = false {
        didSet {
            if !isPhotoPickerPresented, mediaPickers.isEmpty {
                isChangingAvatar = false
                isChangingHeader = false
            }
        }
    }
    
    var isChangingAvatar: Bool = false
    var isChangingHeader: Bool = false
    
    var isLoading: Bool = true
    var isSaving: Bool = false
    var saveError: Bool = false
    
    var mediaPickers: [PhotosPickerItem] = [] {
        didSet {
            if let item = mediaPickers.first {
                Task {
                    if let data = await getItemImageData(item: item) {
                        if isChangingAvatar {
                            _ = await uploadAvatar(data: data)
                        } else if isChangingHeader {
                            _ = await uploadHeader(data: data)
                        }
                        await fetchAccount()
                        isChangingAvatar = false
                        isChangingHeader = false
                        mediaPickers = []
                    }
                }
            }
        }
    }
    
    init() {}
    
    func fetchAccount() async {
        do {
            guard let account = authManager.currentAccount else { return }
            displayName = account.displayName ?? ""
            avatar = account.photoURL
            withAnimation {
                isLoading = false
            }
        } catch {
            
        }
    }
    
    func save() async {
        isSaving = true
        do {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = displayName
            try await changeRequest?.commitChanges()
            isSaving = false
    
        } catch {
            isSaving = false
            saveError = true
        }
    }
    
    private func uploadHeader(data: Data) async -> Bool {
//        guard let client else { return false }
//        do {
//            let response = try await client.mediaUpload(endpoint: Accounts.updateCredentialsMedia,
//                                                        version: .v1,
//                                                        method: "PATCH",
//                                                        mimeType: "image/jpeg",
//                                                        filename: "header",
//                                                        data: data)
//            return response?.statusCode == 200
//        } catch {
            return false
//        }
    }
    
    private func uploadAvatar(data: Data) async -> Bool {
        guard let id = authManager.currentAccount?.uid else { return false }
        let imageName:String = String("\(id).png")
        guard let image = UIImage(data: data) else { return false }
        let storageRef = Storage.storage().reference().child("profilePictures").child(imageName)
        
        if let uploadData = image.pngData() {
            do {
                let metadata = StorageMetadata()
                metadata.contentType = "image/png"
                let result = try await storageRef.putDataAsync(uploadData, metadata: metadata)
                let downloadURL = try await storageRef.downloadURL()
                return await updateProfilePhotoURL(downloadURL)
            } catch let error {
                print(error)
                return false
            }
        } else {
            return false
        }
    }
    
    private func updateProfilePhotoURL(_ url: URL) async -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated")
            return false
        }
        
        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.photoURL = url
        do {
            try await changeRequest.commitChanges()
            print("Profile photo URL updated successfully")
            return true
        } catch let error {
            print("Error updating profile photo URL: \(error)")
            return false
        }
    }
    
//    private func getItemImageData(item: PhotosPickerItem) async -> Data? {
////        guard let imageFile = try? await item.loadTransferable(type: StatusEditor.ImageFileTranseferable.self) else { return nil }
////        
////        let compressor = StatusEditor.Compressor()
////        
////        guard let compressedData = await compressor.compressImageFrom(url: imageFile.url),
////              let image = UIImage(data: compressedData),
////              let uploadData = try? await compressor.compressImageForUpload(image)
////        else { return nil }
////        
////        return uploadData
//        
//        if let data = try? await item.loadTransferable(type: Data.self) {
//            return data
//        }
//        
//        return nil
//    }
    
    private func getItemImageData(item: PhotosPickerItem) async -> Data? {
        // Load the image as Data
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else { return nil }
        
        // Define the desired size for mobile (e.g., 300x300)
        let targetSize = CGSize(width: 100, height: 100)
        
        // Scale the image
        guard let scaledImage = scaleImage(image, to: targetSize) else { return nil }
        
        // Compress the image
        let compressedData = compressImage(scaledImage, quality: 0.7) // Adjust the quality as needed (0.0 to 1.0)
        
        return compressedData
    }
    
    private func compressImage(_ image: UIImage, quality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: quality)
    }
    
    private func scaleImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
