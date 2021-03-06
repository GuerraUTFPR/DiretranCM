require 'rails_helper'

RSpec.describe "cids/show", type: :view do
  before(:each) do
    @cid = assign(:cid, Cid.create!(
      :codigo => "Codigo",
      :nome_doenca => "Nome Doenca"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Codigo/)
    expect(rendered).to match(/Nome Doenca/)
  end
end
