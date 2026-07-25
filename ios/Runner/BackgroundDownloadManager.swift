import Foundation
import Flutter

class BackgroundDownloadManager: NSObject, URLSessionDownloadDelegate {
    static let shared = BackgroundDownloadManager()

    private var urlSession: URLSession!
    private var tasks: [Int: DownloadTask] = [:] // mapping task identifier to model
    private var nativeTasks: [String: URLSessionDownloadTask] = [:] // id to native task

    var progressSink: FlutterEventSink?

    override init() {
        super.init()
        let config = URLSessionConfiguration.background(withIdentifier: "com.dirxplore.background")
        config.sessionSendsLaunchEvents = true
        config.isDiscretionary = false
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)

        // Restore tasks from disk
        let savedTasks = ResumeDataManager.shared.loadAllTasks()
        for task in savedTasks {
            if task.status == .active || task.status == .queued {
                // We might need to reconnect or restart
            }
        }
    }

    func startDownload(url: URL, filename: String, id: String) {
        var taskModel = DownloadTask(id: id, url: url, filename: filename)
        taskModel.status = .active

        let downloadTask: URLSessionDownloadTask
        if let resumeData = ResumeDataManager.shared.getResumeData(for: id) {
            downloadTask = urlSession.downloadTask(withResumeData: resumeData)
        } else {
            downloadTask = urlSession.downloadTask(with: url)
        }

        tasks[downloadTask.taskIdentifier] = taskModel
        nativeTasks[id] = downloadTask
        downloadTask.resume()
        ResumeDataManager.shared.saveTaskMetadata(taskModel)
    }

    func pauseDownload(id: String) {
        guard let task = nativeTasks[id] else { return }
        task.cancel { [weak self] resumeData in
            if let data = resumeData {
                ResumeDataManager.shared.saveResumeData(data, for: id)
            }
            if var model = self?.tasks[task.taskIdentifier] {
                model.status = .paused
                self?.tasks[task.taskIdentifier] = model
                ResumeDataManager.shared.saveTaskMetadata(model)
                self?.notifyFlutter(model)
            }
        }
    }

    func resumeDownload(id: String) {
        guard let model = ResumeDataManager.shared.loadAllTasks().first(where: { $0.id == id }) else { return }
        startDownload(url: model.url, filename: model.filename, id: id)
    }

    func cancelDownload(id: String) {
        nativeTasks[id]?.cancel()
        nativeTasks.removeValue(forKey: id)
        ResumeDataManager.shared.deleteResumeData(for: id)
        // Also remove metadata
    }

    func getActiveTasks() -> [[String: Any]] {
        return ResumeDataManager.shared.loadAllTasks().compactMap { task -> [String: Any]? in
            return [
                "id": task.id,
                "url": task.url.absoluteString,
                "filename": task.filename,
                "status": task.status.rawValue,
                "progress": task.progress,
                "speed": task.speed,
                "downloadedBytes": task.downloadedBytes,
                "totalBytes": task.totalBytes
            ]
        }
    }

    // MARK: - URLSessionDownloadDelegate

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard var model = tasks[downloadTask.taskIdentifier] else { return }

        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destination = docs.appendingPathComponent(model.filename)

        do {
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            try fileManager.moveItem(at: location, to: destination)
            model.status = .completed
            model.progress = 1.0
            notifyFlutter(model)
            ResumeDataManager.shared.saveTaskMetadata(model)
            ResumeDataManager.shared.deleteResumeData(for: model.id)
        } catch {
            model.status = .failed
            model.error = error.localizedDescription
            notifyFlutter(model)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard var model = tasks[downloadTask.taskIdentifier] else { return }

        model.progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        model.downloadedBytes = totalBytesWritten
        model.totalBytes = totalBytesExpectedToWrite
        // Simple speed calculation could be added here

        tasks[downloadTask.taskIdentifier] = model
        notifyFlutter(model)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                // Handled in pause or cancel
                return
            }

            if let downloadTask = task as? URLSessionDownloadTask, var model = tasks[downloadTask.taskIdentifier] {
                model.status = .failed
                model.error = error.localizedDescription

                // Save resume data if available in error
                if let resumeData = nsError.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                    ResumeDataManager.shared.saveResumeData(resumeData, for: model.id)
                }

                notifyFlutter(model)
                ResumeDataManager.shared.saveTaskMetadata(model)
            }
        }
    }

    private func notifyFlutter(_ task: DownloadTask) {
        let data: [String: Any] = [
            "id": task.id,
            "progress": task.progress,
            "speed": task.speed,
            "status": task.status.rawValue,
            "downloadedBytes": task.downloadedBytes,
            "totalBytes": task.totalBytes,
            "error": task.error ?? ""
        ]
        progressSink?(data)
    }
}
