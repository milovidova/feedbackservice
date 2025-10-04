# db/seeds.rb


@raw_text = '
Мы отошли от плоского дизайна в сторону мягкой неоморфизма и сублимированной градиентности. Критически важна оценка того, насколько удачно выстроена воздушная перспектива через использование тональных переходов в рамках основной палитры («туманный серый», «теплый графит», «приглушенный аквамарин»). Не создает ли градиент визуального шума? нализ семантики выбранных оттенков. Передают ли они хрупкий баланс между энергией (еле уловленные салатовые акценты) и релаксацией (доминирующие холодные тона)? Не вызывают ли они пассивности или, наоборот, тревожности? Требуется скрупулезная проверка контрастных соотношений для текстовых блоков и интерактивных элементов (соответствие WCAG AA как минимум). Особое внимание — к цветам состояний (success, warning, error) в их пастельной интерпретации.'
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')


PROJECT_CATEGORIES = ['UI/UX Design', 'Graphic Design', 'Product Design', 'Web Design', 'Mobile Design', 'Brand Identity']
PROJECT_TITLES = [
  "Мобильное приложение для банкинга",
  "Дизайн сайта для кофейни",
  "Лендинг для стартапа",
  "Интерфейс фитнес-трекера",
  "Брендбук для IT компании",
  "UI Kit для социальной сети",
  "Редизайн интернет-магазина",
  "Приложение для доставки еды",
  "Веб-платформа для образования",
  "Мобильный банкинг для подростков",
  "Дизайн системы для SaaS",
  "Логотип и айдентика бренда",
  "Портфолио для фотографа",
  "Интерфейс музыкального сервиса",
  "Дизайн мобильной игры",
  "Админ панель для аналитики",
  "Лендинг для недвижимости",
  "Приложение для медитации",
  "UI/UX для каршеринга",
  "Брендинг для ресторана",
  "Веб-сервис для путешествий",
  "Мобильное приложение для спорта",
  "Дизайн образовательной платформы",
  "Интерфейс для стриминга",
  "Редизайн корпоративного сайта"
]
FEEDBACK_CATEGORIES = ['Typography', 'Color Scheme', 'Usability', 'Composition', 'Concept']

def seed
  reset_db
  create_users(10)
  create_projects(30)
  create_feedbacks(2..6)
end

def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def create_sentence
  sentence_words = []
  (8..15).to_a.sample.times do
    sentence_words << @words.sample
  end
  sentence = sentence_words.join(' ').capitalize + '.'
end

def upload_random_image
  uploader = ProjectImageUploader.new(Project.new, :image)
  uploader.cache!(File.open(Dir.glob(File.join(Rails.root, 'public/autoupload', '*')).sample))
  uploader
end

def create_users(quantity)
  quantity.times do |i|
    user = User.create(
      username: "designer_#{i+1}",
      email: "designer#{i+1}@example.com",
      experience_level: ['Новичок', 'Опытный', 'Эксперт'].sample,
      skills: ['UI/UX дизайн', 'Графический дизайн', 'Иллюстрация'].sample(3).join(', '),
      balance: rand(1..10)
    )

  end
end

def create_projects(quantity)
  users = User.all
  quantity.times do
    project = Project.create(
      user_id: users.sample.id,
      title: PROJECT_TITLES.sample,
      image: upload_random_image,
      description: create_sentence,
      category: PROJECT_CATEGORIES.sample,
      feedback_request: create_sentence
    )
   
  end
end

def create_feedbacks(quantity_range)
  projects = Project.all
  users = User.all
  
  projects.each do |project|
    quantity_range.to_a.sample.times do
        available_users = users.where.not(id: project.user_id)
      
      feedback = Feedback.create(
        project_id: project.id,        
        user_id: available_users.sample.id,
        content: create_sentence,
        category: FEEDBACK_CATEGORIES.sample,
        is_helpful: [true, false].sample
      )
        
    end
  end
end

seed