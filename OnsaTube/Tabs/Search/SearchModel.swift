//
//  SearchModel.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import Foundation
import YouTubeKit

@MainActor
@Observable class Model {
    
    static public let shared = Model()
    
    var items: [any YTSearchResult] = []
    var isFetching: Bool = false
    var isFetchingContination: Bool = false
    var error: String?
    
    enum State {
        case loading
        case error
        case result
        case empty
    }
    
    var state: State = .loading
    
    private var homeResponse: HomeScreenResponse?
    private var searchResponse: SearchResponse?
    private var demoSearchResponse: SearchResponse? {
        didSet {
            VideoPlayerModel.shared.sampleVideo = demoSearchResponse?.results.first as! YTVideo
        }
    }
    
    public func getVideos(_ search: String? = nil, _ end: (() -> Void)? = nil, demo: Bool) {
        if !isFetching, !isFetchingContination {
            if let search = search {
                getVideosForSearch(search, end, demo: demo)
            } else {
                getHomeVideos(end)
            }
        }
    }
    
    public func getVideosContinuation(_ end: (() -> Void)? = nil) {
        if !isFetching, !isFetchingContination {
            if homeResponse != nil {
                getHomeVideosContinuation(end)
            } else {
                getSearchVideosContinuation(end)
            }
        }
    }
    
    private func getHomeVideos(_ end: (() -> Void)?) {
        self.homeResponse = nil
        self.searchResponse = nil
        DispatchQueue.main.async {
            self.isFetching = true
            self.error = nil
        }
        
        
        HomeScreenResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [:], result: { result in
            switch result {
                case .success(let response):
                    self.homeResponse = response
                    DispatchQueue.main.async {
                        self.items = response.results
                        self.isFetching = false
                        end?()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error = error.localizedDescription
                        self.isFetching = false
                        self.items = []
                        end?()
                    }
            }
        })
    }
    
    func fetchVideoList(item: YTPlaylist) async -> PlaylistInfosResponse? {
        let params: [HeadersList.AddQueryInfo.ContentTypes : String] = [
            .browseId: item.playlistId
        ]
        
        do {
            let response = try await PlaylistInfosResponse.sendThrowingRequest(youtubeModel: YTM, data: params)
            return response
        } catch {
            print(error)
            return nil
        }
    }
    
    private func getHomeVideosContinuation(_ end: (() -> Void)?) {
        if let homeResponse = homeResponse, let continuationToken = homeResponse.continuationToken, let visitorData = homeResponse.visitorData {
            DispatchQueue.main.async {
                self.isFetchingContination = true
            }
            
            HomeScreenResponse.Continuation.sendNonThrowingRequest(youtubeModel: YTM, data: [.continuation: continuationToken, .visitorData: visitorData], result: { result in
                switch result {
                    case .success(let response):
                        self.homeResponse?.mergeContinuation(response)
                        DispatchQueue.main.async {
                            if let results = self.homeResponse?.results {
                                self.items = results
                                self.isFetchingContination = false
                            }
                            end?()
                        }
                    case .failure(let error):
                        print("Couldn't fetch home screen continuation: \(String(describing: error))")
                        DispatchQueue.main.async {
                            end?()
                        }
                }
            })
        } else {
            DispatchQueue.main.async {
                end?()
            }
        }
    }
    
    private func getVideosForSearch(_ search: String, _ end: (() -> Void)? ,demo: Bool = false) {
        self.homeResponse = nil
        self.searchResponse = nil
        DispatchQueue.main.async {
            self.isFetching = true
            self.error = nil
        }
        
        SearchResponse.sendNonThrowingRequest(youtubeModel: YTM, data: [.query: search], result: { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let response):
//                    print(response)
                 
                    
                    DispatchQueue.main.async {
                      
                        if demo {
                            self.isFetching = false
                            self.demoSearchResponse = response
                            end?()
                        } else {
                            self.searchResponse = response
                            self.isFetching = false
                            self.items = response.results
                            self.state = self.items.isEmpty ? .empty : .result
                        }
                        
                        end?()
                       
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        self.error = error.localizedDescription
                        self.isFetching = false
                        self.state = .error
                        self.items = []
                        end?()
                    }
            }
        })
    }
    
    private func getSearchVideosContinuation(_ end: (() -> Void)?) {
        if let searchResponse = searchResponse, let continuationToken = searchResponse.continuationToken, let visitorData = searchResponse.visitorData {
            DispatchQueue.main.async {
                self.isFetchingContination = true
//                self.state = .loading
            }
            
            SearchResponse.Continuation.sendNonThrowingRequest(youtubeModel: YTM, data: [.continuation: continuationToken, .visitorData: visitorData], result: { result in
                switch result {
                    case .success(let response):
                        self.searchResponse?.mergeContinuation(response)
                        DispatchQueue.main.async {
                            if let results = self.searchResponse?.results {
                                self.items = results
                                self.isFetchingContination = false
                            }
                            end?()
                        }
                    case .failure(let error):
                        print("Couldn't fetch search screen continuation: \(String(describing: error))")
                        DispatchQueue.main.async {
                            end?()
                        }
                }
            })
        } else {
            DispatchQueue.main.async {
                end?()
            }
        }
    }
}

extension Model {
    static let ytVideo = YTVideo(
        videoId: "gO70C5Q_f6Y",
        title: "The special One",
        thumbnails: [YTThumbnail(url: URL(string: "https://i.ytimg.com/vi/VLFy-a-_wFI/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDhGZLAAHzUFdfBbe2Yx-wS6h3_Dg")!)]
    )
}
