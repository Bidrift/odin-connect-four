require "./lib/players/player"
require "./lib/players/human"

describe Human do # rubocop:disable Metrics/BlockLength
  describe "#get_move" do # rubocop:disable Metrics/BlockLength
    context "when an input is valid" do
      subject(:player) { described_class.new }
      before do
        valid = "3"
        allow(player).to receive(:gets).and_return(valid)
      end

      it "only asks for input once" do
        expect(player).to receive(:gets).once
        player.get_move
      end

      it "returns 3" do
        expect(player.get_move).to eq("3")
      end
    end

    context "when an input is invalid and then valid" do
      subject(:player) { described_class.new }
      before do
        invalid = "a"
        valid = "3"
        allow(player).to receive(:gets).and_return(invalid, valid)
      end

      it "only asks for input twice" do
        expect(player).to receive(:gets).twice
        player.get_move
      end

      it "returns 3" do
        expect(player.get_move).to eq("3")
      end
    end
  end
end
