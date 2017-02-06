import Foundation

class GCDScheduler: Scheduler {

    func inForeground(execute task: @escaping () -> Void) {
        DispatchQueue.main.async(execute: task)
    }

    func inForeground(execute task: @escaping () -> Void, delayedBy delay: DispatchTimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
    }

    func inBackground(execute task: @escaping () -> Void, withPriority priority: DispatchQoS.QoSClass) {
        DispatchQueue.global(qos: .default).async(execute: task)
    }
}

protocol Scheduler: class {
    func inForeground(execute task: @escaping () -> Void)

    func inForeground(execute task: @escaping () -> Void, delayedBy delay: DispatchTimeInterval)

    func inBackground(execute task: @escaping () -> Void, withPriority priority: DispatchQoS.QoSClass)

}

extension Scheduler {
    func execute<T>(task: @escaping () throws -> T, completingBy foregroundCompletion: @escaping (T) -> Void, handlingErrorsBy foregroundFailure: @escaping (Error) -> Void) {
        inBackground(execute: { [weak self] in

            guard let strongSelf = self else {
                return
            }

            do {
                let result = try task()
                strongSelf.inForeground(execute: {
                    foregroundCompletion(result)
                })
            } catch {
                strongSelf.inForeground(execute: {
                    foregroundFailure(error)
                })
            }
        })
    }

    func inBackground(execute task: @escaping () -> Void) {
        inBackground(execute: task, withPriority: .default)
    }
}
