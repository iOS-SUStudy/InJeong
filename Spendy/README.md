# 📚 Project. Spendy (가계부 만들기)

## 📸 프로젝트 완성샷
![screenshot](https://user-images.githubusercontent.com/46644241/105325370-dd2e5c80-5c0f-11eb-8116-cd3e8066317b.gif)
### 🖇 아래와 같이 두 개의 뷰로 구성됨
1. ExpensesList View : List, Edit 버튼, Add 버튼, Delete 기능
2. Add Expense View : Name, Catagory, Amount 입력, Save 버튼
<br>
<br>

## 작업 파일 (폴더링)
- Data/Model/ExpenseItem
    - **ExpenseItem.swift**
    - **ExpenseItem+category.swift**
- Preview Content
    - **SampleData.swift**
- Reusables/Formatters
    - **NumberFormatter.swift**
- Scenes/Expenses
    - **AddExpenseView.swift**
    - **AddExpenseViewModel.swift**
    - **ExpensesListContainerView.swift**
    - **ExpensesListView.swift**
    - **ExpenseListItemView.swift**
    - **ExpensesListViewModel.swift**

<br>
<br>

## 만들어보자!
### 1. Expense Struct / Number Formmat 만들기
- **ExpenseItem.swift** : ExpenseItem 구조 (id, name, category, satoshis)
```swift
struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let category: ExpenseItem.Category
    let satoshis: Double
}
extension ExpenseItem: Codable {}
```
- **ExpenseItem+category.swift** : ExpenseItem의 Category 틀 만들기
```swift
extension ExpenseItem {
    enum Category: String, CaseIterable {
        case coffee
        case food
        case books
        case tools
        
        var displayName: String {
            switch self {
            case .coffee:
                return "Coffee"
            case .food:
                return "Food"
            case .books:
                return "Books"
            case .tools:
                return "Tools"
            }
        }
        
        var systemImageName: String {
            switch self {
            case .coffee:
                return "bolt"
            case .food:
                return "hare"
            case .books:
                return "book"
            case .tools:
                return "wrench"
            }
        }
        
        var iconColor: Color {
            switch self {
            case .coffee:
                return .orange
            case .food:
                return .pink
            case .books:
                return .purple
            case .tools:
                return .green
            }
        }
    }
}

extension ExpenseItem.Category: Codable {}
```
- **NumberFormatter.swift** : 가계부의 Amount에 사용될 금액 포멧 작성
```swift
enum NumberFormatters {
    static let satoshis: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2 //소수점 자리수
        formatter.maximumIntegerDigits = 15 //최대 Digit
        
        return formatter
    }()
}
```
<br>

### 2. Sample Data 넣기
- **SampleData.swift** : 5개의 샘플 데이터를 입력해놓자

```swift
enum SampleExpenses {
    static let `default` = [
        ExpenseItem(name: "Starbucks Coffee", category: .coffee, satoshis: 1_120.49),
        ExpenseItem(name: "16-inch MacBook Pro", category: .tools, satoshis: 50_000_000),
        ExpenseItem(name: "Bone-in Ribeye", category: .food, satoshis: 20_000),
        ExpenseItem(name: "The Odyssey", category: .books, satoshis: 120_000),
        ExpenseItem(name: "Sawada Coffee", category: .coffee, satoshis: 2_921.99),
    ]
}
enum SampleExpensesListViewModel {
    static let `default` = ExpensesListViewModel(expenses: SampleExpenses.default)
}
```
<br>

### 3. List 만들기

1. **ExpenseListItemView.swift** : 먼저 리스트 아이템 하나를 만들어준다
<img width="373" alt="스크린샷 2021-01-21 오후 6 25 06" src="https://user-images.githubusercontent.com/46644241/105330749-ffc37400-5c15-11eb-956b-f5fa4b6e5477.png">

```swift
struct ExpenseListItemView: View {
    let expenseItem: ExpenseItem
}
```
```swift
extension ExpenseListItemView { // body 부분
    var body: some View {
        HStack {
            // 아이콘
            Image(systemName: expenseItem.category.systemImageName)
                .resizable() // 내부 이미지 사이즈 조정
                .scaledToFit() // 내부 이미지 사이즈 조정
                .frame(width: 27, height: 27)
                .padding(13) // 내부 이미지 외부 여백
                .background(expenseItem.category.iconColor)
                .clipShape(Circle()) 
            // 아이템 이름 & 카테고리 이름
            VStack(alignment: .leading) {
                Text("\(expenseItem.name)")
                    .font(.headline)
                
                Text(expenseItem.category.displayName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(expenseItem.category.iconColor)
                    .saturation(0.9)
            }
            Spacer()
            // Amount (만들어 놓은 NumberFormmat 적용)
            Text("\(NumberFormatters.satoshis.string(from: expenseItem.satoshis as NSNumber) ?? "") sat")
                .foregroundColor(Color.secondary)
                .fontWeight(.semibold)
        }
    }
}
```
```swift
struct ExpenseListItemView_Previews: PreviewProvider { // previews 부분
    static var previews: some View {
        ExpenseListItemView(expenseItem: SampleExpenses.default[0])
    }
}
```

2. ExpenseListViewModel.swift : 모델 만들기
```swift
import SwiftUI
import Combine
import UserDefault

final class ExpensesListViewModel: ObservableObject {
    
    @UserDefault("saved-expense-data", defaultValue: Data())
    var savedExpenseData: Data

    @Published var expenses: [ExpenseItem] = [] {
        didSet { saveExpenseData() }
    }

    init(expenses: [ExpenseItem] = []) {
        self.expenses = expenses
    }
    
    init() {
        self.expenses = loadSavedExpenses()
    }
}
```
```swift
extension ExpensesListViewModel {
    func loadSavedExpenses() -> [ExpenseItem] {
        let decoder = JSONDecoder()
        return (try? decoder.decode([ExpenseItem].self, from: savedExpenseData)) ?? []
    }
    func saveExpenseData() {
        let encoder = JSONEncoder()
        savedExpenseData = (try? encoder.encode(expenses)) ?? Data()
    }
}
```

3. List View 만들기

<img width="397" alt="스크린샷 2021-01-21 오후 7 50 15" src="https://user-images.githubusercontent.com/46644241/105340961-e45e6600-5c21-11eb-87c8-2974fcc0c955.png">

```swift
struct ExpensesListView: View {
    @ObservedObject private(set) var viewModel: ExpensesListViewModel
    var onAddExpense: (() -> Void)
}
```
```swift
extension ExpensesListView {
    var body: some View {
        List {
            ForEach(viewModel.expenses) { expenseItem in
                ExpenseListItemView(expenseItem: expenseItem)
            }
            .onDelete(perform: removeItems(at:))
        }
        .navigationBarItems(
            leading: EditButton(),
            trailing: addButton
        )
    }
}
```

```swift
extension ExpensesListView {
    var addButton: some View { 
        Button(action: onAddExpense) {
            Image(systemName: "plus")
                .imageScale(.large)
        }
    }
}
```
```swift
private extension ExpensesListView {
    func removeItems(at offsets: IndexSet) {
        viewModel.expenses.remove(atOffsets: offsets)
    }
}
```
```swift
struct ExpensesList_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesListView(
            viewModel: SampleExpensesListViewModel.default,
            onAddExpense: {}
        )
        .accentColor(.pink)
    }
}
```
### 4. Add View 만들기
1. AddExpenseViewModel.swift 
2. AddExpenseView.swift : Expense 추가 뷰 만들기
```swift
struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = AddExpenseViewModel()
    var save: ((ExpenseItem) -> Void)
}
```
```swift
extension AddExpenseView {
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Name"),
                    footer: Text(viewModel.nameErrorMessage ?? "")
                        .foregroundColor(.red)
                ) {
                    TextField("Expense Name", text: $viewModel.expenseName)
                }
                
                Section(header: Text("Category")) {
                    VStack(spacing: 14.0) {
                        Picker("Category", selection: $viewModel.category) {
                            ForEach(ExpenseItem.Category.allCases, id: \.self) { category in
                                Image(systemName: category.systemImageName)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Text(viewModel.category.displayName)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                }
                
                Section(
                    header: Text("Amount"),
                    footer: Text(viewModel.satoshisErrorMessage ?? "")
                        .foregroundColor(.red)
                ) {
                    TextField("Amount of satoshis spent", text: $viewModel.amountText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("New Expense")
            .navigationBarItems(trailing: saveButton)
        }
    }
}
```
```swift
extension AddExpenseView {
    private var saveButton: some View {
        Button(action: {
            guard let newExpenseItem = self.viewModel.newExpenseItem else {
                preconditionFailure()
            }
            self.save(newExpenseItem)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save")
        }
        .disabled(!viewModel.isFormValid)
    }
}
```
```swift
struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(save: { _ in })
    }
}
```
### 5. 마지막으로 두개 뷰 합치기 (최종 View)
- ExpensesListContainerView.swift 만들기
```swift
struct ExpensesListContainerView: View {
    var viewModel = ExpensesListViewModel()
    
    @State private var isShowingAddView = false
}
```
```swift
extension ExpensesListContainerView {
    var body: some View {
        NavigationView {
            ExpensesListView(
                viewModel: viewModel,
                onAddExpense: { self.isShowingAddView = true }
            )
            .navigationBarTitle("Spendy")
        }
        .sheet(isPresented: $isShowingAddView) {
            AddExpenseView { expenseItem in
                self.viewModel.expenses.append(expenseItem)
            }
        }
    }
}

```
```swift
struct ExpensesListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesListContainerView(viewModel: SampleExpensesListViewModel.default)
            .accentColor(.pink)
    }
}
```
