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
- ExpenseItem.swift : ExpenseItem 구조 (id, name, category, satoshis)
```swift
struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let category: ExpenseItem.Category
    let satoshis: Double
}
extension ExpenseItem: Codable {}
```
- ExpenseItem+category.swift : ExpenseItem의 Category 틀 만들기
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
- NumberFormatter.swift : 가계부의 Amount에 사용될 금액 포멧 작성
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

### 2. Sample Data 넣기
- sampleData.swift : 5개의 샘플 데이터를 입력해놓자
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

