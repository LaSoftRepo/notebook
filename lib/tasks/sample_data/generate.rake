namespace :sample_data do
  desc 'Generates a sample data for the app'
  task generate: :environment do
    notebooks(create_user)
  end
end

def notebooks(user)
  15.times { sections(create_notebook(user)) }
end

def sections(notebook)
  rand(1..3).times do
    s1 = create_section_with_notices(notebook)
    rand(1..2).times do
      s2 = create_child_section_with_notices(s1)
      rand(1..2).times do
        s3 = create_child_section_with_notices(s2)
        rand(1..2).times do
          create_child_section_with_notices(s3)
        end
      end
    end
  end
end

def notices(section)
  rand(5..20).times { create_notice(section) }
end

def create_section_with_notices(notebook)
  section = create_section(notebook)
  notices(section)
  section
end

def create_child_section_with_notices(section)
  child_section = create_child_section(section)
  notices(child_section)
  child_section
end

def create_user
  User.create!(
    name:  'Vitalik Paprotsky',        # Faker::Name.name
    email: 'vetalpaprotsky@gmail.com', # Faker::Internet.email
    password: '12345678',
    password_confirmation: '12345678'
  )
end

def create_notebook(user)
  user.notebooks.create!(
    name: fake_name
  )
end

def create_section(notebook)
  notebook.sections.create!(
    name: fake_name,
    description: Faker::Lorem.paragraph
  )
end

def create_child_section(section)
  section.child_sections.create!(
    name: fake_name,
    description: Faker::Lorem.paragraph
  )
end

def create_notice(section)
  section.notices.create!(
    name: fake_name,
    text: Faker::Lorem.paragraph(rand(10..15))
  )
end

def fake_name
  Faker::Lorem.words(rand(1..3)).map(&:capitalize).join(' ')
end
