import Foundation

/// Подсказка при вводе «На что?»: «Migros» → «Продукты».
struct Suggestion: Identifiable, Hashable {
    let note: String
    let categoryID: UUID
    let currency: Currency?
    let lastAmount: Decimal?
    let count: Int
    /// Страны (по валюте), где это место есть. Пусто — подходит везде или это своё место из истории.
    let places: Set<Currency>
    /// Ключи для поиска: само название и другие написания («Карфур» для Carrefour).
    let keys: [String]

    var id: String { keys[0] }

    init(note: String, categoryID: UUID, currency: Currency? = nil, lastAmount: Decimal? = nil, count: Int = 0,
         places: Set<Currency> = [], aliases: [String] = []) {
        self.note = note
        self.categoryID = categoryID
        self.currency = currency
        self.lastAmount = lastAmount
        self.count = count
        self.places = places
        var keys = [SuggestionEngine.key(note)]
        for alias in aliases {
            let key = SuggestionEngine.key(alias)
            if !key.isEmpty && !keys.contains(key) { keys.append(key) }
        }
        self.keys = keys
    }
}

/// Знакомое место или слово из стартовых подсказок.
struct SuggestionSeed {
    let note: String
    /// Название категории; «Подписка» — особая категория, как бы её ни переименовали.
    let category: String
    let places: Set<Currency>
    let aliases: [String]
    let keys: [String]
}

enum SuggestionEngine {
    // MARK: Ключ: одно и то же место по-русски и латиницей

    /// Ключ для сравнения названий. «Мигрос» и «Migros», «шок» и «ŞOK», «филе» и «File»,
    /// «тюрк телеком» и «Türk Telekom» дают один ключ: кириллица переводится в латиницу,
    /// похожие звуки и написания сводятся к одному. Только для сравнения — на экран не выводится.
    static func key(_ text: String) -> String {
        // Турецкие буквы — до снятия точек: ç и ş — это «ч» и «ш», ğ не слышно, ı — «и».
        var s = text.lowercased()
            .replacingOccurrences(of: "ı", with: "i")
            .replacingOccurrences(of: "ç", with: "ч")
            .replacingOccurrences(of: "ş", with: "ш")
            .replacingOccurrences(of: "ğ", with: "")
            .folding(options: .diacriticInsensitive, locale: nil)
        // Латинские сочетания — одной буквой, как их слышат: sh — «ш», ch — «ч», x — «кс».
        for (from, to) in latinSounds { s = s.replacingOccurrences(of: from, with: to) }

        let chars = Array(s)
        var out = ""
        for (i, ch) in chars.enumerated() {
            switch ch {
            // «c» как в английском: перед e, i, y — «с» (Macrocenter), иначе — «к» (Carrefour).
            case "c": out += "eiy".contains(i + 1 < chars.count ? chars[i + 1] : " ") ? "s" : "k"
            case "'", "’", "`", "ʼ": break
            default:
                if let sound = letterSounds[ch] {
                    out += sound
                } else if ch.isLetter || ch.isNumber {
                    out.append(ch)
                } else {
                    out += " "
                }
            }
        }
        return out.split(separator: " ").map { simplify(Array($0)) }.filter { !$0.isEmpty }.joined(separator: " ")
    }

    private static let latinSounds: [(String, String)] = [
        ("sch", "ш"), ("sh", "ш"), ("ch", "ч"), ("zh", "ж"), ("kh", "х"), ("th", "т"), ("ph", "ф"), ("ck", "к"), ("x", "кс"),
    ]

    /// Буква → звук латиницей. Я и ю — с «й» впереди: он уйдёт после согласной («пятёрочка» = «pyaterochka»).
    private static let letterSounds: [Character: String] = [
        "а": "a", "б": "b", "в": "v", "г": "g", "д": "d", "е": "e", "ж": "j", "з": "z", "и": "i", "й": "i",
        "к": "k", "л": "l", "м": "m", "н": "n", "о": "o", "п": "p", "р": "r", "с": "s", "т": "t", "у": "u",
        "ф": "f", "х": "h", "ц": "ts", "ч": "c", "ш": "s", "щ": "s", "ъ": "", "ы": "i", "ь": "", "э": "e",
        "ю": "iu", "я": "ia", "y": "i", "w": "v", "q": "k",
    ]

    private static let vowels: Set<Character> = ["a", "e", "i", "o", "u"]

    /// Одно слово ключа: без двойных букв, «ou» = «u», без «й» перед гласной, без немой «e» на конце.
    private static func simplify(_ word: [Character]) -> String {
        var single: [Character] = []
        for ch in word where single.last != ch { single.append(ch) }
        let w = Array(String(single).replacingOccurrences(of: "ou", with: "u"))
        var result: [Character] = []
        for (i, ch) in w.enumerated() {
            // «й» перед гласной в начале слова и после согласной — не в счёт: «Yandex» = «яндекс», «Trendyol» = «трендол».
            if ch == "i", i + 1 < w.count, vowels.contains(w[i + 1]), i == 0 || !vowels.contains(w[i - 1]) { continue }
            result.append(ch)
        }
        // Немая «e» на конце: «File» = «филе», «Vodafone» = «водафон».
        if result.count >= 4, result.last == "e", !vowels.contains(result[result.count - 2]) { result.removeLast() }
        return String(result)
    }

    /// Для «набрано ровно это»: без регистра и точек над буквами.
    static func normalize(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
    }

    // MARK: Подсказки

    /// История пользователя (чаще используемое — выше), затем стартовые подсказки.
    /// Своё написание знакомого места показывается привычным: «мигрос» — как «Migros».
    static func build(expenses: [Expense], categories: [ExpenseCategory]) -> [Suggestion] {
        let validIDs = Set(categories.map(\.id))
        var seedByKey: [String: SuggestionSeed] = [:]
        for seed in seeds {
            for key in seed.keys where seedByKey[key] == nil { seedByKey[key] = seed }
        }
        let groups = Dictionary(grouping: expenses.filter { !key($0.note).isEmpty }) { key($0.note) }

        var result: [Suggestion] = groups.compactMap { groupKey, items in
            let sorted = items.sorted { $0.date > $1.date }
            let counts = Dictionary(grouping: sorted.filter { validIDs.contains($0.categoryID) }, by: \.categoryID)
            guard let latest = sorted.first,
                  let categoryID = counts.max(by: { $0.value.count < $1.value.count })?.key
            else { return nil }
            let seed = seedByKey[groupKey]
            return Suggestion(note: seed?.note ?? latest.note.trimmingCharacters(in: .whitespacesAndNewlines),
                              categoryID: categoryID, currency: latest.currency, lastAmount: latest.amount,
                              count: items.count, aliases: seed?.aliases ?? [])
        }
        result.sort { $0.count != $1.count ? $0.count > $1.count : $0.note < $1.note }

        var known = Set(result.flatMap(\.keys))
        for seed in seeds where !seed.keys.contains(where: known.contains) {
            let category = seed.category == ExpenseCategory.subscription.name
                ? categories.first(where: \.isSubscription)
                : categories.first { $0.name == seed.category }
            guard let category else { continue }
            result.append(Suggestion(note: seed.note, categoryID: category.id, places: seed.places, aliases: seed.aliases))
            known.formUnion(seed.keys)
        }
        return result
    }

    /// Подходящие места: сначала точное совпадение по звучанию («мигрос» → Migros), потом по началу слова,
    /// потом по середине. Внутри — своё из истории, места этой страны, общие слова, места других стран.
    /// Пока ничего не набрано — частые свои места, а у нового пользователя — известные места страны валюты.
    static func match(_ query: String, in all: [Suggestion], near currency: Currency? = nil, limit: Int = 5) -> [Suggestion] {
        let q = key(query)
        guard !q.isEmpty else {
            let own = all.filter { $0.count > 0 }
            let here = currency.map { cur in all.filter { $0.count == 0 && $0.places.contains(cur) } } ?? []
            return Array((own + here).prefix(limit))
        }
        let typed = normalize(query)
        var found: [(tier: Int, place: Int, index: Int)] = []
        for (index, s) in all.enumerated() where normalize(s.note) != typed {
            let tier: Int
            if s.keys.contains(q) {
                tier = 0
            } else if s.keys.contains(where: { $0.hasPrefix(q) || $0.split(separator: " ").contains { $0.hasPrefix(q) } }) {
                tier = 1
            } else if s.keys.contains(where: { $0.contains(q) }) {
                tier = 2
            } else {
                continue
            }
            let place = placeRank(s, near: currency)
            // Места других стран — только по точному названию или если набрано уже 4 буквы.
            if place == 3 && tier > 0 && q.count < 4 { continue }
            found.append((tier, place, index))
        }
        found.sort { ($0.tier, $0.place, $0.index) < ($1.tier, $1.place, $1.index) }
        return found.prefix(limit).map { all[$0.index] }
    }

    /// 0 — своё из истории, 1 — место этой страны, 2 — общее слово, 3 — место другой страны.
    private static func placeRank(_ s: Suggestion, near currency: Currency?) -> Int {
        if s.count > 0 { return 0 }
        if s.places.isEmpty { return 2 }
        if let currency, s.places.contains(currency) { return 1 }
        return 3
    }

    /// Знакомое место, как его ни напиши: «мигрос», «Мигрос», «migros» — это Migros.
    static func exact(_ note: String, in all: [Suggestion]) -> Suggestion? {
        let q = key(note)
        return q.isEmpty ? nil : all.first { $0.keys.contains(q) }
    }

    /// Как записать трату: знакомое место — привычным написанием («мигрос» → «Migros»), остальное — как набрано.
    static func canonical(_ note: String, in all: [Suggestion]) -> String {
        let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
        return exact(trimmed, in: all)?.note ?? trimmed
    }

    /// Знакомое место в названии с чека — целыми словами: «MİGROS TİCARET A.Ş.» — это Migros,
    /// а «du» не найдётся внутри «Dünyası».
    static func place(onReceipt merchant: String, in all: [Suggestion]) -> Suggestion? {
        let words = " \(key(merchant)) "
        return all.first { s in s.keys.contains { words.contains(" \($0) ") } }
    }

    /// Категория по словам в названии, если место незнакомое: «Kasap Ali» — «Продукты», «Nur Eczanesi» — «Здоровье»,
    /// «кафе у дома» — «Кафе». nil — если ни одно слово не подсказывает.
    static func guessCategory(_ note: String, in categories: [ExpenseCategory]) -> ExpenseCategory? {
        let words = key(note).split(separator: " ")
        guard !words.isEmpty else { return nil }
        for (stem, name) in categoryWords where words.contains(where: { $0.hasPrefix(stem) }) {
            if let category = categories.first(where: { $0.name == name }) { return category }
        }
        return nil
    }

    // MARK: Стартовые подсказки

    /// Все стартовые подсказки: места по странам валют, общие слова, сети, которые есть почти везде.
    static let seeds: [SuggestionSeed] =
        parse(turkey, places: [.lira]) + parse(uzbekistan, places: [.uzs]) + parse(russia, places: [.rub])
        + parse(emirates, places: [.aed]) + parse(europe, places: [.eur]) + parse(usa, places: [.usd])
        + parse(words, places: []) + parse(chains, places: [])

    /// Строка таблицы: «Название | Категория | другие написания через запятую | валюты стран».
    /// Страны по умолчанию — у всей таблицы; четвёртая колонка, если есть, их заменяет («UZS RUB»).
    private static func parse(_ table: String, places: Set<Currency>) -> [SuggestionSeed] {
        table.split(separator: "\n").compactMap { line in
            let parts = line.split(separator: "|", omittingEmptySubsequences: false).map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count >= 2, !parts[0].isEmpty, !parts[0].hasPrefix("#") else { return nil }
            let aliases = parts.count > 2 ? parts[2].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } : []
            let own = parts.count > 3 ? Set(parts[3].split(separator: " ").compactMap { Currency(code: String($0)) }) : places
            var keys = [key(parts[0])]
            for alias in aliases where !keys.contains(key(alias)) { keys.append(key(alias)) }
            return SuggestionSeed(note: parts[0], category: parts[1], places: own, aliases: aliases, keys: keys)
        }
    }

    /// Турция: сети, коммунальные и турецкие слова, которые пишут и по-русски («фатура», «эджзане»).
    private static let turkey = """
    Migros | Продукты
    BİM | Продукты
    A101 | Продукты
    ŞOK | Продукты
    File Market | Продукты
    Macrocenter | Продукты | Макроцентр
    Hakmar | Продукты
    Mopaş | Продукты
    Happy Center | Продукты
    Onur Market | Продукты
    Kasaba | Продукты
    Bizim Toptan | Продукты
    Tarım Kredi | Продукты
    Metro Market | Продукты
    Pazar | Продукты
    Manav | Продукты
    Kasap | Продукты
    Fırın | Продукты
    Ekmek | Продукты
    Bakkal | Продукты
    Kahve Dünyası | Кафе
    Simit Sarayı | Кафе
    Simit | Кафе
    Espressolab | Кафе
    Popeyes | Кафе | Попайс
    Döner | Кафе | Дёнер, Донер
    Kebap | Кафе
    Lahmacun | Кафе | Лахмаджун
    Pide | Кафе
    Börek | Кафе | Бёрек
    Lokanta | Кафе
    Getir | Доставка
    Yemeksepeti | Доставка
    Trendyol Yemek | Доставка
    Kargo | Доставка
    Aras Kargo | Доставка
    Yurtiçi Kargo | Доставка
    PTT | Доставка
    İstanbulkart | Транспорт
    BiTaksi | Транспорт
    Dolmuş | Транспорт
    Otobüs | Транспорт
    Opet | Транспорт
    Petrol Ofisi | Транспорт
    Aytemiz | Транспорт
    Otopark | Транспорт
    HGS | Транспорт
    Fatura | Жильё
    Kira | Жильё
    Aidat | Жильё
    Elektrik | Жильё
    Doğalgaz | Жильё | Догалгаз
    Enerjisa | Жильё | Энерджиса
    İGDAŞ | Жильё
    İSKİ | Жильё
    Turkcell | Связь
    Vodafone | Связь
    Türk Telekom | Связь
    Superonline | Связь
    TurkNet | Связь
    Eczane | Здоровье | Эджзане, Эзджане
    Hastane | Здоровье
    Trendyol | Покупки
    Hepsiburada | Покупки
    n11 | Покупки
    Teknosa | Покупки
    Vatan Bilgisayar | Покупки
    Gratis | Покупки
    Watsons | Покупки
    Kırtasiye | Покупки
    LC Waikiki | Одежда | Вайкики
    Koton | Одежда
    DeFacto | Одежда
    Mavi | Одежда
    Boyner | Одежда
    Flo | Одежда
    Penti | Одежда
    Koçtaş | Для дома
    English Home | Для дома | Инглиш Хоум
    Hırdavat | Для дома
    Biletix | Досуг
    Çiçek | Подарки | Чичек
    Hediye | Подарки
    Pegasus | Поездки
    Turkish Airlines | Поездки | Туркиш Эйрлайнс
    AJet | Поездки | Аджет
    SunExpress | Поездки
    Obilet | Поездки
    Berber | Другое
    Kuaför | Другое | Куафёр
    BluTV | Подписка
    Exxen | Подписка
    Gain | Подписка
    TOD | Подписка
    """

    /// Узбекистан.
    private static let uzbekistan = """
    Korzinka | Продукты
    Makro | Продукты
    Havas | Продукты
    Baraka Market | Продукты
    Chorsu | Продукты | Чорсу
    Evos | Кафе
    Les Ailes | Кафе | Лез Эль
    Oqtepa Lavash | Кафе | Октепа, Окттепа
    Besh Qozon | Кафе | Беш Казан, Беш Козон
    Чайхана | Кафе
    Плов | Кафе
    Самса | Кафе
    Лаваш | Кафе
    Express24 | Доставка | Экспресс24
    Uzum Tezkor | Доставка
    Uzum Market | Покупки
    MyTaxi | Транспорт | Майтакси
    Ucell | Связь
    Uzmobile | Связь | Узмобайл
    Mobiuz | Связь | Мобиуз
    """

    /// Россия.
    private static let russia = """
    Пятёрочка | Продукты
    Магнит | Продукты
    Перекрёсток | Продукты
    Лента | Продукты
    Ашан | Продукты | Auchan
    ВкусВилл | Продукты
    Дикси | Продукты
    Fix Price | Покупки | Фикс Прайс
    Ozon | Покупки
    Wildberries | Покупки | Вайлдберриз, ВБ
    Яндекс Маркет | Покупки
    М.Видео | Покупки
    DNS | Покупки | ДНС
    Детский мир | Покупки
    Яндекс Лавка | Доставка
    Самокат | Доставка
    Яндекс Еда | Доставка
    МТС | Связь | MTS
    МегаФон | Связь
    Т2 | Связь | Теле2, Tele2
    Тройка | Транспорт
    Шоколадница | Кафе
    Вкусно — и точка | Кафе
    Додо Пицца | Кафе | Dodo
    Теремок | Кафе
    Ригла | Здоровье
    Спортмастер | Одежда
    Леруа Мерлен | Для дома | Лемана ПРО
    ЖКХ | Жильё | ЖКУ
    Okko | Подписка
    Кинопоиск | Подписка
    """

    /// ОАЭ.
    private static let emirates = """
    Lulu | Продукты
    Spinneys | Продукты | Спиннис
    Waitrose | Продукты
    Choithrams | Продукты
    Union Coop | Продукты
    Talabat | Доставка
    Noon | Покупки | Нун
    Careem | Транспорт | Карим
    Salik | Транспорт
    Nol | Транспорт | Нол
    RTA | Транспорт
    ENOC | Транспорт
    ADNOC | Транспорт
    DEWA | Жильё
    Etisalat | Связь
    du | Связь
    Tim Hortons | Кафе
    Costa Coffee | Кафе
    """

    /// Европа.
    private static let europe = """
    Lidl | Продукты
    Aldi | Продукты
    Rewe | Продукты
    Edeka | Продукты
    Kaufland | Продукты
    Mercadona | Продукты
    Monoprix | Продукты
    dm | Покупки
    Rossmann | Покупки
    MediaMarkt | Покупки
    Primark | Одежда
    Bauhaus | Для дома
    Deliveroo | Доставка
    Bolt | Транспорт
    Deutsche Bahn | Поездки
    Ryanair | Поездки
    easyJet | Поездки
    Wizz Air | Поездки
    """

    /// США.
    private static let usa = """
    Walmart | Продукты
    Target | Продукты
    Costco | Продукты
    Whole Foods | Продукты
    Trader Joe's | Продукты
    Kroger | Продукты
    CVS | Здоровье
    Walgreens | Здоровье
    Chipotle | Кафе
    Subway | Кафе
    Dunkin' | Кафе
    Lyft | Транспорт
    Home Depot | Для дома
    Best Buy | Покупки
    Verizon | Связь
    AT&T | Связь
    T-Mobile | Связь
    """

    /// Сети и сервисы, которые есть почти везде.
    private static let chains = """
    Carrefour | Продукты | CarrefourSA, Карфур, Карфурса | TRY UZS AED EUR
    Starbucks | Кафе | Старбакс
    McDonald's | Кафе | Макдональдс, Макдак
    Burger King | Кафе
    KFC | Кафе | КФС
    Domino's | Кафе
    Yandex Go | Транспорт | Яндекс Такси | UZS RUB
    Uber | Транспорт
    Shell | Транспорт
    BP | Транспорт
    Wolt | Доставка | | UZS EUR
    Amazon | Покупки
    Apple | Покупки | Эпл
    Zara | Одежда
    H&M | Одежда | HM, Эйч энд Эм
    Decathlon | Досуг
    IKEA | Для дома
    Booking | Поездки | Букинг
    Airbnb | Поездки | Эйрбиэнби
    Beeline | Связь | Билайн | UZS RUB
    Netflix | Подписка | Нетфликс
    YouTube Premium | Подписка | Ютуб
    Spotify | Подписка
    Apple Music | Подписка
    iCloud | Подписка | Айклауд
    Apple TV+ | Подписка
    Disney+ | Подписка | Дисней
    Amazon Prime | Подписка
    Google One | Подписка
    ChatGPT | Подписка | Чат GPT
    Microsoft 365 | Подписка
    Telegram Premium | Подписка | Телеграм
    Яндекс Плюс | Подписка | Yandex Plus | RUB UZS
    """

    /// Общие слова — по-русски (латиницей тоже находятся: «apteka» → «Аптека»).
    private static let words = """
    Продукты | Продукты
    Хлеб | Продукты
    Молоко | Продукты
    Овощи | Продукты
    Фрукты | Продукты
    Мясо | Продукты
    Рыба | Продукты
    Рынок | Продукты
    Базар | Продукты
    Магазин | Продукты
    Market | Продукты
    Вода | Продукты
    Кафе | Кафе
    Кофе | Кафе
    Ресторан | Кафе
    Обед | Кафе
    Ужин | Кафе
    Завтрак | Кафе
    Шаурма | Кафе
    Пицца | Кафе
    Кебаб | Кафе
    Доставка | Доставка
    Курьер | Доставка
    Почта | Доставка
    Такси | Транспорт
    Автобус | Транспорт
    Метро | Транспорт
    Трамвай | Транспорт
    Маршрутка | Транспорт
    Бензин | Транспорт
    Заправка | Транспорт
    Парковка | Транспорт
    Мойка | Транспорт
    Аренда | Жильё
    Коммуналка | Жильё
    Квартплата | Жильё
    Свет | Жильё
    Газ | Жильё
    Ремонт | Жильё
    Интернет | Связь
    Телефон | Связь
    Аптека | Здоровье
    Лекарства | Здоровье
    Врач | Здоровье
    Стоматолог | Здоровье
    Анализы | Здоровье
    Больница | Здоровье
    Витамины | Здоровье
    Одежда | Одежда
    Обувь | Одежда
    Посуда | Для дома
    Бытовая химия | Для дома
    Мебель | Для дома
    Кино | Досуг
    Театр | Досуг
    Музей | Досуг
    Концерт | Досуг
    Спортзал | Досуг
    Бассейн | Досуг
    Книги | Досуг
    Подарок | Подарки
    Цветы | Подарки
    Отель | Поездки
    Авиабилеты | Поездки
    Поезд | Поездки
    Парикмахер | Другое
    Стрижка | Другое
    Налоги | Другое
    Штраф | Другое
    """

    /// Слова, по которым угадывается категория незнакомого места (начало слова, по-русски или латиницей).
    private static let categoryWords: [(String, String)] = {
        let table: [(String, [String])] = [
            ("Продукты", ["market", "маркет", "bakkal", "manav", "kasap", "kasab", "fırın", "ekmek", "pazar", "базар",
                          "рынок", "хлеб", "gıda", "супермаркет", "продукт", "мясн", "овощ", "фрукт", "şarküteri"]),
            ("Кафе", ["кафе", "cafe", "kahve", "кофе", "coffee", "restoran", "ресторан", "restaurant", "lokanta", "kebap",
                      "кебаб", "döner", "шаурм", "pide", "lahmacun", "pizza", "пицц", "burger", "бургер", "simit", "börek",
                      "pastane", "кондитер", "столов", "чайхан"]),
            ("Доставка", ["kargo", "доставк", "курьер", "delivery"]),
            ("Транспорт", ["taksi", "такси", "taxi", "otobüs", "автобус", "dolmuş", "метро", "benzin", "бензин", "akaryakıt",
                           "otopark", "парков", "мойк", "yıkama"]),
            ("Жильё", ["kira", "аренд", "aidat", "fatura", "elektrik", "электр", "doğalgaz", "коммунал", "квартплат"]),
            ("Связь", ["internet", "интернет", "telefon", "телефон", "мобил"]),
            ("Здоровье", ["eczane", "аптек", "pharmacy", "hastane", "больниц", "doktor", "врач", "клиник", "klinik",
                          "анализ", "лекарств", "стомат"]),
            ("Одежда", ["одежд", "обув", "ayakkabı", "giyim"]),
            ("Для дома", ["hırdavat", "mobilya", "мебел", "посуд", "хозтовар"]),
            ("Досуг", ["sinema", "кино", "cinema", "müze", "музе", "konser", "концерт", "tiyatro", "театр", "спортзал", "бассейн"]),
            ("Подарки", ["hediye", "подар", "çiçek", "цвет"]),
            ("Поездки", ["otel", "отел", "hotel", "uçak", "авиа", "поезд"]),
            ("Другое", ["berber", "парикмах", "kuaför", "стрижк", "vergi", "налог", "штраф"]),
        ]
        return table.flatMap { name, stems in stems.map { (key($0), name) } }.filter { $0.0.count >= 3 }
    }()
}
