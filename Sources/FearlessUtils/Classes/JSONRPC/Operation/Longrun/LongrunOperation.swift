import Foundation
import RobinHood

public class LongrunOperation<T>: BaseOperation<T> {
    public let longrun: AnyLongrun<T>

    public init(longrun: AnyLongrun<T>) {
        self.longrun = longrun
    }

    public override func main() {
        super.main()

        if isCancelled {
            return
        }

        if result != nil {
            return
        }

        var longrunResult: Result<T, Error>?

        let semaphore = DispatchSemaphore(value: 0)

        longrun.start { result in
            longrunResult = result

            semaphore.signal()
        }

        semaphore.wait()

        if isCancelled {
            return
        }

        result = longrunResult
    }

    public override func cancel() {
        super.cancel()

        longrun.cancel()
    }
}
