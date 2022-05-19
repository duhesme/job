import Foundation

struct Item {
    var itemId: Int
    var name: String
    var price: Float
    var count: Int
}

class Order {

    var items: [Int: Item] = [:]
    var deleteBlock: (()->(Void))?
    var timer: Timer?

    /// сумма заказа
    var total: Float {
        return items.map({$0.value}).map({$0.price}).reduce(0, +)
    }
    
    ///  Добавить товар к заказу
    func put(item: Item) {
        if items[item.itemId] == nil {
            items[item.itemId] = item
        } else {
            items[item.itemId]!.count += item.count
        }
    }
    
    /// Посчитать заказ и подготовить к отправке
    func make() -> [[String: Int]] {
        var data: [[String: Int]] = []
        
        data = items.map { item in
            [String(item.key): item.value.count]
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
