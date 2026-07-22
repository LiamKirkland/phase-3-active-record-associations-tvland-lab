describe Network do
  let(:adult_swim) { Network.first }

  before do
    network = Network.create(channel: 50, call_letters: "AS")
    show = Show.create(name: "Aqua Teen Hunger Force", network: network)
    
    snyder = Actor.create(first_name: "Dana", last_name: "Snyder")
    means  = Actor.create(first_name: "Carey", last_name: "Means")
    willis = Actor.create(first_name: "Dave", last_name: "Willis")

    Character.create(name: "Master Shake", show_id: show.id, actor_id: snyder.id)
    Character.create(name: "Frylock", show_id: show.id, actor_id: means.id)
    Character.create(name: "Meatwad", show_id: show.id, actor_id: willis.id)
  end

  it "has a channel and call_letters" do
    expect(adult_swim).to have_attributes(channel: 50, call_letters: "AS")
  end

  describe "#shows" do
    it "returns the shows associated with the network" do
      athf = Show.find_by(name: "Aqua Teen Hunger Force")
      expect(adult_swim.shows).to include(athf)
    end
  end

  describe "#first_show_actors" do
    it "returns a string containing the show name, actors (full names), and their characters" do
      result = adult_swim.first_show_actors

      expect(result).to include("Aqua Teen Hunger Force", "Dana Snyder", "Master Shake", "Carey Means", "Frylock", "Dave Willis", "Meatwad")
    end
  end
end
