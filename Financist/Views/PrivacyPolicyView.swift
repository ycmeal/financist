import SwiftUI

/// Тот же текст лежит в PRIVACY.md в корне репозитория (ссылка для App Store).
struct PrivacyPolicyView: View {
    private struct Item: Identifiable {
        let symbol: String
        let title: String
        let body: String
        var id: String { title }
    }

    private let items: [Item] = [
        Item(symbol: "iphone", title: "Только на этом iPhone",
             body: "Траты хранятся только на вашем телефоне. Нет аккаунтов, серверов, рекламы и аналитики. Данные не попадают в iCloud и в резервные копии."),
        Item(symbol: "lock.fill", title: "Шифрование",
             body: "Данные зашифрованы AES-256-GCM. Ключ создаётся на вашем iPhone и хранится в Связке ключей с доступом «только на этом устройстве, только когда оно разблокировано». Дополнительно iOS шифрует файл, пока телефон заблокирован. Ни у разработчика, ни у Apple ключа нет."),
        Item(symbol: "chart.pie.fill", title: "Статистика",
             body: "Итоги, графики и подсказки считаются прямо на телефоне. Ничего не отправляется наружу."),
        Item(symbol: "arrow.left.arrow.right", title: "Курсы валют",
             body: "Чтобы узнать курсы, приложение скачивает общую таблицу с open.er-api.com. В запросе нет ваших трат, сумм или имени — только «дай курсы». Сервис видит лишь IP-адрес, как любой сайт. Это единственное обращение в интернет, его можно выключить в «Курсах валют»."),
        Item(symbol: "doc.text.viewfinder", title: "Сканер чеков",
             body: "Текст с чека читает встроенный в iOS распознаватель прямо на телефоне. Фото не сохраняется и никуда не отправляется."),
        Item(symbol: "bell.fill", title: "Напоминания",
             body: "Напоминания создаёт сам iPhone, без серверов. В них нет сумм и названий — только «Записали траты?»."),
        Item(symbol: "mic.fill", title: "Siri",
             body: "Siri и кнопка действия только открывают ввод траты. Суммы и траты Siri не передаются."),
        Item(symbol: "keyboard", title: "Клавиатура",
             body: "В приложении работает только системная клавиатура iOS. Сторонние клавиатуры отключены — они могли бы передавать набранный текст."),
        Item(symbol: "faceid", title: "Face ID",
             body: "Проверку делает сама iOS. Приложение получает только ответ «да» или «нет» и никогда не видит ваше лицо или отпечаток. В переключателе приложений экран скрыт."),
        Item(symbol: "lock.rectangle.on.rectangle.fill", title: "Виджет",
             body: "Виджет на экране блокировки — просто кнопка. Он не видит и не показывает ваши траты."),
        Item(symbol: "iphone.and.arrow.forward", title: "Перенос",
             body: "Файл переноса создаётся только по вашей команде и шифруется вашим паролем (PBKDF2-SHA256, 310 000 итераций, затем AES-256-GCM). Пароль нигде не сохраняется. Таблица для Excel не зашифрована."),
        Item(symbol: "clock.arrow.circlepath", title: "Копии на телефоне",
             body: "Чтобы траты не потерялись из-за сбоя, приложение хранит несколько копий своего файла: ежедневную, еженедельную и перед обновлениями. Они зашифрованы тем же ключом, лежат только на телефоне и не попадают в iCloud. Удалённые траты 30 дней лежат в «Недавно удалённых»."),
        Item(symbol: "trash.fill", title: "Удаление",
             body: "«Удалить все данные» стирает траты, все копии и ключ шифрования. Удаление приложения тоже стирает всё."),
    ]

    var body: some View {
        List {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.title, systemImage: item.symbol)
                        .font(.headline)
                    Text(item.body)
                }
                .padding(.vertical, 4)
            }
            Section {
                Text("Редакция от 28 октября 2026 года.")
                    .foregroundStyle(.secondary)
            }
        }
        .warmListBackground()
        .navigationTitle("Конфиденциальность")
        .navigationBarTitleDisplayMode(.inline)
    }
}
