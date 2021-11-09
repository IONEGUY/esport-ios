//
//  FileLoader.swift
//  SmARt
//
//  Created by MacBook on 11.03.21.
//

import Foundation
import Combine
import Alamofire

class FileLoader: NSObject, URLSessionDownloadDelegate {
    private var taskProgresses: [String: Float] = [:]
    private var urlSession: URLSession?
    private var files: [String: FileProtocol] = [:]
    private var lock = NSLock()
    
    var progress = PassthroughSubject<Progress, Never>()
    
    override init() {
        super.init()
        
        let config = URLSessionConfiguration.background(withIdentifier: "\(UUID().uuidString).background")
        config.timeoutIntervalForRequest = 1000
        config.timeoutIntervalForResource = 1000
        config.allowsCellularAccess = true
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }
    
    func stopAllOperations() {
        urlSession?.invalidateAndCancel()
    }
    
    private func download(file: FileProtocol) {
        guard let url = URL(string: file.url),
              let task = urlSession?.downloadTask(with: URLRequest(url: url)) else { return }
        taskProgresses[url.absoluteString] = 0
        files[url.absoluteString] = file
        task.resume()
    }
    
    func download(files: [FileProtocol]) {
        files.forEach(download)
    }
    
    func uploadFile(fileURL: URL, url: URL) {
        let user = "upload_user"
        let password = "2Fa37cvs8NvT74"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        AF.upload(multipartFormData: { $0.append(fileURL, withName: "file") },
                  to: url,
                  headers: HTTPHeaders(headers))
            .response { [unowned self] responce in
                progress.send(responce.error != nil ? .failed : .finished)
            }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0, let url = downloadTask.originalRequest?.url?.absoluteString {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            refreshProgress(url, progress)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let dataFromURL = try? Data(contentsOf: location),
           let file = files[downloadTask.originalRequest?.url?.absoluteString ?? .empty] {
            let url = URL.constructFilePath(withName: file.nameWithExtension)
            try? dataFromURL.write(to: url)
            refreshProgress(file.url, 1)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil { return }
        if let file = files[task.originalRequest?.url?.absoluteString ?? .empty] {
            refreshProgress(file.url, 1)
        }
    }
    
    func refreshProgress(_ url: String, _ progressForTask: Float) {
        lock.lock()
        
        let taskProgressesCount = Float(taskProgresses.values.count == 0 ? 1 : taskProgresses.values.count)
        let progress = Float(taskProgresses.values.reduce(0, +)) / taskProgressesCount
        if progress == 0 { self.progress.send(.started) }
        taskProgresses[url] = progressForTask
        print(progress)
        if progress >= Constants.completeProgressValue {
            self.progress.send(.finished)
            self.progress.send(completion: .finished)
        } else {
            self.progress.send(.value(progress))
        }

        lock.unlock()
    }
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {}
}
