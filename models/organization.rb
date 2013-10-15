class Organization  < Ohm::Model

  attribute :guid
  attribute :o_data

  index :guid

  def self.store org
    new_org = find(:guid => org.guid).first
    new_org ||= new
    new_org.guid = org.guid
    new_org.o_data = Marshal::dump(org)
    new_org.save
  end

  def self.rebuild guid
    Marshal::load find(:guid => guid).first.o_data
  end

end
