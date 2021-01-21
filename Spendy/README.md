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

### 3. List 만들기 (첫 번째 뷰)

1. **ExpenseListItemView.swift** : 먼저 아래와 같은 리스트 아이템 하나를 만들어준다
<img width="373" alt="스크린샷 2021-01-21 오후 6 25 06" src="https://user-images.githubusercontent.com/46644241/105330749-ffc37400-5c15-11eb-956b-f5fa4b6e5477.png">

```swift
struct ExpenseListItemView: View {
    let expenseItem: ExpenseItem 
    //위에서 만든 ExpenseItem 틀에 맞춰 데이터를 받아옴
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
- @UserDefault : 데이터 저장소, 앱의 어느 위치에서든 즉시 데이터를 읽고 저장할 수 있음 (key, defaultValue)으로 정의 (@State와 비슷함)
- @Published : 변화가 있을 때마다 알림을 보냄
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
- load : Expense List 불러오기 / decode
- save : Expense List 저장하기 / encode
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

3. ExpensesListView.swift : List View 만들기
- 위에 만들어놓은 모델과 하나의 항목를 이용해서 아래 그림과 같은전체 리스트 구성
<img width="397" alt="스크린샷 2021-01-21 오후 7 50 15" src="https://user-images.githubusercontent.com/46644241/105340961-e45e6600-5c21-11eb-87c8-2974fcc0c955.png">

- 초기 변수 셋팅
- @ObservedObject : 알림설정 느낌, 변화가 있을 때마다 보내는 알림을 받음
```swift
struct ExpensesListView: View {
    @ObservedObject private(set) var viewModel: ExpensesListViewModel
    var onAddExpense: (() -> Void)
}
```
- Expense 내역을 ForEach로 하나하나 List Item View에 넣어줌
```swift
extension ExpensesListView {
    var body: some View {
        List {
            ForEach(viewModel.expenses) { expenseItem in
                ExpenseListItemView(expenseItem: expenseItem)
            }
            // 항목을 왼쪽으로 슬라이드 시, Delete 가능하도록
            .onDelete(perform: removeItems(at:))
        }
        .navigationBarItems(
            leading: EditButton(), // Edit버튼 추가
            trailing: addButton // add버튼 추가
        )
    }
}
```
- add 버튼 정의 
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
- delete 정의
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
1. AddExpenseViewModel.swift : 소스코드 길어서 못가져옴ㅠㅠ 파일 찾아서 내용 복사
2. AddExpenseView.swift : Expense 추가 뷰 만들기
```swift
struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = AddExpenseViewModel()
    var save: ((ExpenseItem) -> Void)
}
```
```swift
extension AddExpenseView { // body 부분
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
                preconditionFailure() // 전제조건위반 exception
            }
            self.save(newExpenseItem)
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save")
        }
        .disabled(!viewModel.isFormValid) 
        // 폼이 완성되지 않으면 버튼 disabled 처리, 완성될때만 버튼 활성화
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
    @State private var isShowingAddView = false // 처음엔 addview 숨기기
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
<br>

> 2021년 1월 20일 SwiftUI 스터디

    days 036~038
    Project7 : iExpense
