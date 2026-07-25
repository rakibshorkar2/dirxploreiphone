import Foundation

enum DownloadStatus: String, Codable {
    case queued
    case active
    case paused
    case completed
    case failed
}

struct DownloadTask: Codable {
    let id: String
    let url: URL
    let filename: String
    var status: DownloadStatus
    var progress: Double
    var speed: Double
    var downloadedBytes: Int64
    var totalBytes: Int64
    var resumeData: Data?
    var error: String?

    init(id: String, url: URL, filename: String) {
        self.id = id
        self.url = url
        self.filename = filename
        self.status = .queued
        self.progress = 0
        self.speed = 0
        self.downloadedBytes = 0
        self.totalBytes = 0
    }
}
