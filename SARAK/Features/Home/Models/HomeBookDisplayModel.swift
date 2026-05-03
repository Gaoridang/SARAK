// HomeBookDisplayModel.swift — SARAK
import Foundation

struct HomeBookDisplayModel {
    let id: UUID
    let title: String
    let author: String
    let progress: Double  // 0.0 – 1.0
    let currentPage: Int?
    let totalPages: Int?
    let status: BookStatus
}
