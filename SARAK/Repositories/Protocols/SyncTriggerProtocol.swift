// SyncTriggerProtocol.swift — SARAK
import Foundation

@MainActor
protocol SyncTriggerProtocol {
    func syncPendingChanges() async
}
