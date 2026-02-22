FactoryBot.define do
  factory :items_dependency do
    listitem { nil }
    depends_on { 1 }
  end
end
