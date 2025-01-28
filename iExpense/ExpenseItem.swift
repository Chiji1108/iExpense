//
//  ExpenseItem.swift
//  iExpense
//
//  Created by 千々岩真吾 on 2024/06/04.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
