import Foundation
import RobinHood

public extension CompoundOperationWrapper {
    func addDependency(operations: [Operation]) {
        allOperations.forEach { nextOperation in
            operations.forEach { prevOperation in
                nextOperation.addDependency(prevOperation)
            }
        }
    }

    func addDependency(wrapper: CompoundOperationWrapper) {
        addDependency(operations: wrapper.allOperations)
    }
}
