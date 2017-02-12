def fake_name
  Faker::Lorem.words(rand(1..4)).map(&:capitalize).join(' ')
end

def fake_sentence
  Faker::Lorem.sentence
end

user = User.where(email: 'vetalpaprotsky@gmail.com').first
notebook = Notebook.where(name: 'Rails').first

if user.nil? && notebook.nil?
  user = User.create(name: 'Vitalik Paprotsky',
                     email: 'vetalpaprotsky@gmail.com',
                     password: '12345678',
                     password_confirmation: '12345678')

  notebook = Notebook.create(name: 'Rails', user_id: user.id)

  models = Section.new(name: 'Models', description: fake_sentence)
  models.notices.build(name: fake_name, text: fake_sentence)
  migrations = models.child_sections.build(name: 'Migrations', description: fake_sentence)
  migrations.notices.build(name: fake_name, text: fake_sentence)
  migrations.notices.build(name: fake_name, text: fake_sentence)
  creating_migration = migrations.child_sections.build(name: 'Creating a migration', description: fake_sentence)
  creating_migration.notices.build(name: fake_name, text: fake_sentence)

  views = Section.new(name: 'Views', description: fake_sentence)
  rendering = views.child_sections.build(name: 'Rendering', description: fake_sentence)
  rendering.notices.build(name: fake_name, text: fake_sentence)

  controllers = Section.new(name: 'Controllers', description: fake_sentence)
  actions = controllers.child_sections.build(name: 'Actions', description: fake_sentence)
  actions.notices.build(name: fake_name, text: fake_sentence)

  notebook.sections.push(models, views, controllers)
  notebook.upsert

  notebook2 = Notebook.create(name: 'JavaScript', user_id: user.id)
  notebook2.upsert
end
