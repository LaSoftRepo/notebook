user = User.where(email: 'vetalpaprotsky@gmail.com').first
notebook = Notebook.where(name: 'Rails').first

if user.nil? && notebook.nil?
  user = User.create(email: 'vetalpaprotsky@gmail.com',
                     password: '12345678',
                     password_confirmation: '12345678')

  notebook = Notebook.create(name: 'Rails', user_id: user.id)

  sec1 = Section.new(name: 'sec1', description: '...')
  sec1.notices.build(name: 'sec1_not1', text: '...')
  sec1_sub1 = sec1.sub_sections.build(name: 'sec1_sub1', description: '...')
  sec1_sub1.notices.build(name: 'sec1_sub1_not1', text: '...')
  sec1_sub1.notices.build(name: 'sec1_sub1_not2', text: '...')
  sec1_sub1_sub1 = sec1_sub1.sub_sections.build(name: 'sec1_sub1_sub1', description: '...')
  sec1_sub1_sub1.notices.build(name: 'sec1_sub1_sub1_not1', text: '...')

  sec2 = Section.new(name: 'sec2', description: '...')
  sec2_sub1 = sec2.sub_sections.build(name: 'sec2_sub1', description: '...')
  sec2_sub1.notices.build(name: 'sec2_sub1_not1', text: '...')

  notebook.sections.push(sec1, sec2)
  notebook.upsert
end
