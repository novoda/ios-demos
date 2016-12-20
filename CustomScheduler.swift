import Foundation

class GCDScheduler: Scheduler {
	
	func runInForeground(task: () -> Void) {
		dispatch_async(dispatch_get_main_queue(), task)
	}
	
	func runInForegroundDelayed(by delay: Double, _ task: () -> Void) {
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
		dispatch_after(time, dispatch_get_main_queue(), task)
	}
	
	func runInBackground(task: () -> Void) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), task)
	}
}

protocol Scheduler : class {
    func runInForeground(task: () -> Void)
    func runInForegroundDelayed(by delay: Double, _ task: () -> Void)
    func runInBackground(task: () -> Void)
}

extension Scheduler {
    func runInBackground<T>(task: () throws -> T, foregroundCompletion: (T) -> Void, foregroundFailure: (ErrorType) -> Void) {
        runInBackground({ [weak self] in
            
            guard let  strongSelf = self else {
                return
            }
            
            do {
                let result = try task()
                strongSelf.runInForeground({
                    foregroundCompletion(result)
                })
            } catch {
                strongSelf.runInForeground({
                    foregroundFailure(error)
                })
            }
        })
    }
}
