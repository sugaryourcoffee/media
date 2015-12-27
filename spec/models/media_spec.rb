require 'rails_helper'

describe Media do

  it "should respond to attributes" do
    media = Media.new

    expect(media).to respond_to(:title)
    expect(media).to respond_to(:subtitle)
    expect(media).to respond_to(:description)
    expect(media).to respond_to(:publisher)
    expect(media).to respond_to(:edition)
    expect(media).to respond_to(:date_of_issue)
    expect(media).to respond_to(:language)
    expect(media).to respond_to(:age_rating)
    expect(media).to respond_to(:ratings)
    expect(media).to respond_to(:comments)
    expect(media).to respond_to(:links)
    expect(media).to respond_to(:vendors)
    expect(media).to respond_to(:icon_small)
    expect(media).to respond_to(:icon_medium)
    expect(media).to respond_to(:icon_large)
    expect(media).to respond_to(:gengre)
    expect(media).to respond_to(:isxn)
    expect(media).to respond_to(:artists)
    expect(media).to respond_to(:storage_position)
    expect(media).to respond_to(:media_center)
    expect(media).to respond_to(:tags)
    expect(media).to respond_to(:for_sale)
    expect(media).to respond_to(:price)
    expect(media).to respond_to(:lendable)
  end

  it "requires a title" do
  end

  it "requires an author" do
  end

end
