//
//  ContentView.swift
//  iExpense
//
//  Created by 千々岩真吾 on 2024/06/04.
//

import SwiftUI

struct Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
    
    var personalItems: [ExpenseItem] {
        get {
            items.filter { $0.type == "Personal" }
        }
        set {
            self.items = items.filter { $0.type != "Personal" } + newValue
        }
    }
    
    var businessItems: [ExpenseItem] {
        get {
            items.filter { $0.type == "Business" }
        }
        set {
            self.items = items.filter { $0.type != "Business" } + newValue
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    let localCurrency = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.personalItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(item.amount, format: .currency(code: localCurrency))
                                .foregroundStyle(item.amount < 10 ? .blue : item.amount < 100 ? .yellow : .red)
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code: "USD")))")
                        .accessibilityHint(item.type)
                    }
                    .onDelete {
                        expenses.personalItems.remove(atOffsets: $0)
                    }
                    .onMove {
                        expenses.personalItems.move(fromOffsets: $0, toOffset: $1)
                    }
                }
                
                Section("Business") {
                    ForEach(expenses.businessItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(item.amount < 10 ? .blue : item.amount < 100 ? .yellow : .red)
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code: "USD")))")
                        .accessibilityHint(item.type)
                    }
                    .onDelete {
                        expenses.businessItems.remove(atOffsets: $0)
                    }
                    .onMove {
                        expenses.businessItems.move(fromOffsets: $0, toOffset: $1)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expenses: $expenses)
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
//                Button("Add Expense", systemImage: "plus") {
//                    showingAddExpense = true
//                }
                EditButton()
            }
        }
//        .sheet(isPresented: $showingAddExpense) {
//            AddView(expenses: $expenses)
//        }
    }
}

#Preview {
    ContentView()
}
