require 'rails_helper'

# 方法是用單數
RSpec.describe Course do
  it {is_expected.to validate_presence_of(:title)}
  it {expect(subject).to validate_presence_of(:title)}
  it {is_expected.to belong_to(:user)}
end
