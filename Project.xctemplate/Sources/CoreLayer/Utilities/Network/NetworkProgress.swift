// ___FILEHEADER___

import Moya
import PromiseKit

struct NetworkProgress {
    private let progress: Progress
    
    static func request() -> NetworkProgress? {
        guard let currentProgress = Progress.current() else { return nil }
        
        let progress = Progress(parent: currentProgress)
        progress.isCancellable = false
        progress.totalUnitCount = 0
        progress.completedUnitCount = 0
        
        return NetworkProgress(progress: progress)
    }
    
    static func download(to fileUrl: URL) -> NetworkProgress? {
        assert(fileUrl.isFileURL, "We expect url to be `fileURL`.")
        
        guard let currentProgress = Progress.current() else { return nil }
        
        let userInfo: [ProgressUserInfoKey: Any] = [.fileOperationKindKey: Progress.FileOperationKind.downloading,
                                                    .fileURLKey: fileUrl]
        
        let progress = Progress(parent: currentProgress, userInfo: userInfo)
        progress.kind = .file
        progress.isCancellable = false
        progress.totalUnitCount = 0
        progress.completedUnitCount = 0
        
        return NetworkProgress(progress: progress)
    }
    
    func report(_ response: Moya.ProgressResponse) {
        progress.totalUnitCount = response.progressObject?.totalUnitCount ?? 0
        progress.completedUnitCount = response.progressObject?.completedUnitCount ?? 0
    }
    
    func fail() {
        progress.completedUnitCount = 0
    }
}

extension NetworkProgress {
    func inspect<T>(promise: Promise<T>, on queue: DispatchQueue) -> Promise<T> {
        return promise.tap(on: queue) { result in
            if !result.isFulfilled {
                DispatchQueue.main.async(execute: self.fail)
            }
        }
    }
}
