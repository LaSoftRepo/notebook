user = User.where(email: 'vetalpaprotsky@gmail.com').first
notebook = Notebook.where(name: 'Rails').first

if user.nil? && notebook.nil?
  user = User.create(name: 'vetal paprotsky',
                     email: 'vetalpaprotsky@gmail.com',
                     password: '12345678',
                     password_confirmation: '12345678')

  notebook = Notebook.create(name: 'Rails', user_id: user.id)

  models = Section.new(name: 'Models', description: '...')
  models.notices.build(name: '...', text: '...')
  migrations = models.sub_sections.build(name: 'Migrations', description: '...')
  migrations.notices.build(name: '...', text: '...')
  migrations.notices.build(name: '...', text: '...')
  creating_migration = migrations.sub_sections.build(name: 'Creating a migration', description: '...')
  creating_migration.notices.build(name: '...', text: '...')

  views = Section.new(name: 'Views', description: '...')
  rendering = views.sub_sections.build(name: 'Rendering', description: '...')
  rendering.notices.build(name: '...', text: '...')

  controllers = Section.new(name: 'Controllers', description: '...')
  actions = controllers.sub_sections.build(name: 'Actions', description: '...')
  actions.notices.build(name: '...', text: '...')

  notebook.sections.push(models, views, controllers)
  notebook.upsert

  notebook2 = Notebook.create(name: 'JavaScript', user_id: user.id)
  notebook2.upsert
end
