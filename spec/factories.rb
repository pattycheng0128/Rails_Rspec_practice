FactoryBot.define do

  factory :course do
    title {Faker::Name.unique.name}
    description {Faker::Company.logo}
  end

end