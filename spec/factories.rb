FactoryBot.define do
  factory :user do
    email {Faker::Internet.email}
    password {Faker::Config.random}
    password_confirmation {password}
  end


  factory :course do
    title {Faker::Name.unique.name}
    description {Faker::Company.logo}
  end

end