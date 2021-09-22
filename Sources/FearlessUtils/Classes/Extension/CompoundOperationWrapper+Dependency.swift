import Foundation
import RobinHood

public extension CompoundOperationWrapper {
    public  func addDependency(operations: [Operation]) {
        allOperations.forEach { nextOperation in
            operations.forEach { prevOperation in
                nextOperation.addDependency(prevOperation)
            }
        }
    }

    public func addDependency(wrapper: CompoundOperationWrapper) {
        addDependency(operations: wrapper.allOperations)
    }
}
