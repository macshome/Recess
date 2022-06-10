import Cocoa
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

typealias TaskBlock = () -> Void

struct RepeatingTask {
    let identifier: String
    let interval: TimeInterval
    let block: TaskBlock
}


class Tasks {

    lazy var schedulers = [NSBackgroundActivityScheduler]()
lazy var timers = [Timer]()

    func makeTask(_ task: RepeatingTask) {
        if task.interval >= 20 {
            scheduleBackgroundTask(identifier: task.identifier,
                                   interval: task.interval) { completion in
                                    task.block()
                                    completion(.finished)
            }

        } else {
            makeRepeatingTask(interval: task.interval, block: { timer in task.block() })
            }
        }

w
func makeRepeatingTask(interval: TimeInterval, block: @escaping (Timer) -> Void) {
    let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: block)
    timer.tolerance = interval * 0.10
    timers.append(timer)
    }

    func scheduleBackgroundTask(identifier: String,
                                interval: TimeInterval,
                                block: @escaping ((NSBackgroundActivityScheduler.CompletionHandler) -> Void)) {

        let scheduler = NSBackgroundActivityScheduler(identifier: identifier)
        scheduler.repeats = true
        scheduler.interval = interval
        scheduler.qualityOfService = .utility
        scheduler.tolerance = interval * 0.05 // we should keep it around 5%
        scheduler.schedule(block)
        schedulers.append(scheduler)
    }

    func invalidateAll() {
        schedulers.forEach {$0.invalidate()}
        timers.forEach {$0.invalidate()}
    }
}
let task = RepeatingTask(identifier: "foo.bar.test",
                         interval: 20,
                         block: { print("long test") }  )

let tasktwo = RepeatingTask(identifier: "foo.bar.test.two",
                         interval: 5,
                         block: { print("quick test") }  )
let foo = Tasks()

foo.makeTask(task)
foo.makeTask(tasktwo)

//
foo.invalidateAll()
