import Foundation

struct Item: Hashable {
    var itemId: Int
    var name: String
    var price: Float
}

class Order {

    var items: [Item: Int] = [:]
    var deleteBlock: (()->(Void))?
    var timer: Timer?

    /// сумма заказа
    var total: Float {
        return items.map({$0.key.price * Float($0.value)}).reduce(0, +)
    }
    
    ///  Добавить товар к заказу
    func put(item: Item) {
        if items[item] == nil {
            items[item] = 1
        } else {
            items[item]! += 1
        }
    }
    
    /// Посчитать заказ и подготовить к отправке
    func make() -> [[String: Int]] {
        var data: [[String: Int]] = []
        
        data = items.map { item in
            [String(item.key.itemId): item.value]
        }
        
        return data
    }

    /// удалить товары из заказа через 20 секунд
    func deleteAfter20Seconds(block: (()->(Void))?) {
        if let t = timer {
            t.invalidate()
        }
        
        self.deleteBlock = block
        self.timer = Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { (timer) in
            self.delete()
        })
    }
    
    /// отменить удаление товаров
    func cancelDelete() {
        timer?.invalidate()
        timer = nil
    }

    ///очистка товаров
    func delete() {
        items = [:]
        deleteBlock?()
    }
}
