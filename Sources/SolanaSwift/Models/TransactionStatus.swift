import Foundation

public enum TransactionStatus: Equatable, Hashable {
    case sending
    case confirmed(numberOfConfirmations: UInt64, slot: UInt64?)
    case finalized
    case error(String?)

    public var numberOfConfirmations: UInt64 {
        switch self {
        case let .confirmed(numberOfConfirmations, _):
            return numberOfConfirmations
        default:
            return 0
        }
    }
    
    public var slot: UInt64? {
        switch self {
        case let .confirmed(_, slot):
            return slot
        default:
            return nil
        }
    }
}
