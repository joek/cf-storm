class App  < Ohm::Model

  attribute :guid
  attribute :o_data

  index :guid

  def self.store app
    new_app = find(:guid => app.guid).first
    new_app ||= new
    new_app.guid = app.guid
    new_app.o_data = Marshal::dump(app)
    new_app.save
  end

  def self.rebuild guid
    Marshal::load find(:guid => guid).first.o_data
  end

end
