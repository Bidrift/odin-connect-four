require "./lib/connectfour"
require "./lib/items/board"
require "./lib/players/player"

describe ConnectFour do # rubocop:disable Metrics/BlockLength
  describe "#initialize" do
    # Script
  end

  describe "#createboard" do
    subject(:board_game) { described_class.new }
    it "sets @board to an instance of Board" do
      expect { board_game.create_board }.to change { board_game.instance_variable_get(:@board).class }.to be(Board)
    end
  end

  describe "#create_players" do
    subject(:player_game) { described_class.new }
    it "sets an array of length 2" do
      expect { player_game.create_players }.to change { player_game.instance_variable_get(:@players).length }.to be(2)
    end
    it "sets an array with Player instances" do
      expect { player_game.create_players }.to change {
                                                 player_game.instance_variable_get(:@players)
                                                            .map(&:class)
                                               }.to all(be(Player))
    end
  end

  describe "#over?" do # rubocop:disable Metrics/BlockLength
    context "when there is a winner" do
      let(:board) { instance_double(Board) }
      subject(:game_over) { described_class.new(board) }
      before do
        allow(board).to receive(:winner_exists?).and_return(true)
      end

      it "returns true" do
        expect(game_over).to be_over
      end
    end
    context "when the board is full" do
      let(:board) { instance_double(Board) }
      subject(:game_over) { described_class.new(board) }
      before do
        allow(board).to receive(:winner_exists?).and_return(false)
        allow(board).to receive(:full?).and_return(true)
      end

      it "returns true" do
        expect(game_over).to be_over
      end
    end
    context "when the board is neither full nor there is a winner" do
      let(:board) { instance_double(Board) }
      subject(:game_over) { described_class.new(board) }
      before do
        allow(board).to receive(:winner_exists?).and_return(false)
        allow(board).to receive(:full?).and_return(false)
      end

      it "returns false" do
        expect(game_over).not_to be_over
      end
    end
  end

  describe "#run_game" do # rubocop:disable Metrics/BlockLength
    context "when there are no turns left" do
      let(:board) { instance_double(Board) }
      subject(:game_run) { described_class.new(board) }

      before do
        allow(game_run).to receive(:over?).and_return(false)
        allow(game_run).to receive(:show_winner)
      end

      it "does not play any turn" do
        expect(game_run).not_to receive(:play_turn)
        game_run.run_game
      end
    end

    context "when there is one turn left" do
      let(:board) { instance_double(Board) }
      subject(:game_run) { described_class.new(board) }

      before do
        allow(game_run).to receive(:over?).and_return(true, false)
        allow(game_run).to receive(:show_winner)
      end

      it "plays 1 turn" do
        expect(game_run).to receive(:play_turn).once
        game_run.run_game
      end
    end

    context "when there is multiple turns left" do
      let(:board) { instance_double(Board) }
      subject(:game_run) { described_class.new(board) }

      before do
        allow(game_run).to receive(:over?).and_return(true, true, true, false)
        allow(game_run).to receive(:show_winner)
      end

      it "plays 3 turns" do
        expect(game_run).to receive(:play_turn).exactly(3).times
        game_run.run_game
      end
    end
  end

  describe "#play_turn" do
    let(:board) { instance_double(Board) }
    let(:player) { instance_double(Player) }
    context "when it's player 0's turn" do
      subject(:game_play) { described_class.new(board, player) }

      before do
        allow(board).to receive(:display_board)
        allow(game_play).to receive(:get_player_move).with(player)
        allow(board).to receive(:save_move)
      end

      it "updates turn to 1" do
        expect { game_play.play_turn }.to change { game_play.instance_variable_get(:@turn) }.by(1)
      end
    end

    context "when it's player 1's turn" do
      subject(:game_play) { described_class.new(board, player, 1) }

      before do
        allow(board).to receive(:display_board)
        allow(game_play).to receive(:get_player_move).with(player)
        allow(board).to receive(:save_move)
      end

      it "updates turn to 0" do
        expect { game_play.play_turn }.to change { game_play.instance_variable_get(:@turn) }.by(-1)
      end
    end
  end

  describe "#get_player_move" do
    let(:board) { instance_double(Board) }
    let(:player) { instance_double(Player) }
    subject(:game_play) { described_class.new(board, player) }
    context "when the player has correct input" do
      before do
        valid_input = 1
        allow(player).to receive(:get_move).and_return(valid_input)
        allow(board).to receive(:valid_move?).and_return(true)
      end

      it "asks for input once" do
        expect(player).to receive(:get_move).once
      end

      it "returns the move the player has chosen (1)" do
        expect(game_play.get_player_move(player)).to eq(1)
      end
    end

    context "when the player has wrong then correct input" do
      before do
        wrong = 1
        valid_input = 2
        allow(player).to receive(:get_move).and_return(wrong, valid_input)
        allow(board).to receive(:valid_move?).and_return(false, true)
      end

      it "asks for input twice" do
        expect(player).to receive(:get_move).twice
      end

      it "returns only the valid move (2)" do
        expect(game_play.get_player_move(player)).to eq(2)
      end
    end
  end
end
