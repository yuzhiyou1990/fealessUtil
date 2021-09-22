import Foundation
import RobinHood

extension BaseOperation {
    public static func createWithError(_ error: Error) -> BaseOperation<ResultType> {
        let operation = BaseOperation<ResultType>()
        operation.result = .failure(error)
        return operation
    }

    public static func createWithResult(_ result: ResultType) -> BaseOperation<ResultType> {
        let operation = BaseOperation<ResultType>()
        operation.result = .success(result)
        return operation
    }

    public  func extractNoCancellableResultData() throws -> ResultType {
        try extractResultData(throwing: BaseOperationError.parentOperationCancelled)
    }
}
