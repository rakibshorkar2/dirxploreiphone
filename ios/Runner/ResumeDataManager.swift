import Foundation

class ResumeDataManager {
    static let shared = ResumeDataManager()

    private let fileManager = FileManager.default
    private var resumeDataFolder: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = docs.appendingPathComponent(".resumeData", isDirectory: true)
        if !fileManager.fileExists(atPath: folder.path) {
            try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    func saveResumeData(_ data: Data, for id: String) {
        let fileURL = resumeDataFolder.appendingPathComponent("\(id).resume")
        try? data.write(to: fileURL)
    }

    func getResumeData(for id: String) -> Data? {
        let fileURL = resumeDataFolder.appendingPathComponent("\(id).resume")
        return try? Data(contentsOf: fileURL)
    }

    func deleteResumeData(for id: String) {
        let fileURL = resumeDataFolder.appendingPathComponent("\(id).resume")
        try? fileManager.removeItem(at: fileURL)
    }

    func saveTaskMetadata(_ task: DownloadTask) {
        let fileURL = resumeDataFolder.appendingPathComponent("\(task.id).json")
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(task) {
            try? data.write(to: fileURL)
        }
    }

    func loadAllTasks() -> [DownloadTask] {
        guard let files = try? fileManager.contentsOfDirectory(at: resumeDataFolder, includingPropertiesForKeys: nil) else {
            return []
        }
        let decoder = JSONDecoder()
        return files.filter { $0.pathExtension == "json" }.compactMap { url in
            if let data = try? Data(contentsOf: url) {
                return try? decoder.decode(DownloadTask.self, from: data)
            }
            return nil
        }
    }
}
