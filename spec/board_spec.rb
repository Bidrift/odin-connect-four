require "./lib/items/board"
require "./lib/items/item"

RSpec.shared_examples "diagonal checks" do
  it "checks rows" do
    expect(subject).to receive(:check_rows).and_return(false)
    subject.winner_exists?
  end
  it "checks columns" do
    expect(subject).to receive(:check_cols).and_return(false)
    subject.winner_exists?
  end
  it "checks diagonals" do
    expect(subject).to receive(:check_diag).and_return(true)
    subject.winner_exists?
  end
  it "returns true" do
    expect(subject).to be_winner_exists
  end
end

describe Board do
  describe "#winner_exists?" do
    context "when there is no winning combination" do
      let(:item) { instance_double(Item) }
      subject(:no_win) { described_class.new }
      it "checks rows" do
        expect(no_win).to receive(:check_rows).and_return(false)
        no_win.winner_exists?
      end
      it "checks columns" do
        expect(no_win).to receive(:check_cols).and_return(false)
        no_win.winner_exists?
      end
      it "checks diagonals" do
        expect(no_win).to receive(:check_diag).and_return(false)
        no_win.winner_exists?
      end
      it "returns false" do
        expect(no_win).not_to be_winner_exists
      end
    end
    context "when there is a row winning combination" do
      let(:item) { instance_double(Item) }
      subject(:row_win) { described_class.new([Array.new(4, item)]) }
      it "checks rows" do
        expect(row_win).to receive(:check_rows).once.and_return(true)
        row_win.winner_exists?
      end
      it "does not check columns" do
        expect(row_win).not_to receive(:check_cols)
        row_win.winner_exists?
      end
      it "does not check diagonals" do
        expect(row_win).not_to receive(:check_diag)
        row_win.winner_exists?
      end
      it "returns true" do
        expect(row_win).to be_winner_exists
      end
    end
    context "when there is a column winning combination" do
      let(:item) { instance_double(Item) }
      subject(:col_win) { described_class.new([[item], [item], [item], [item]]) }
      it "checks rows" do
        expect(col_win).to receive(:check_rows).and_return(false)
        col_win.winner_exists?
      end
      it "checks columns" do
        expect(col_win).to receive(:check_cols).and_return(true)
        col_win.winner_exists?
      end
      it "does not check diagonals" do
        expect(col_win).not_to receive(:check_diag)
        col_win.winner_exists?
      end
      it "returns true" do
        expect(col_win).to be_winner_exists
      end
    end
    context "when there is a diagonal winning combination (top left to bottom right)" do
      let(:item) { instance_double(Item) }
      subject(:dia_win) do
        described_class.new([[item, nil, nil, nil], [nil, item, nil, nil], [nil, nil, item, nil],
                             [nil, nil, nil, item]])
      end
      include_examples "diagonal checks"
    end
    context "when there is a diagonal winning combination (bottom left to top right)" do
      let(:item) { instance_double(Item) }
      subject(:dia_win) do
        described_class.new([[nil, nil, nil, item], [nil, nil, item, nil], [nil, item, nil, nil],
                             [item, nil, nil, nil]])
      end
      include_examples "diagonal checks"
    end
  end

  describe "full?" do
    context "when the board is empty" do
      subject(:empty_board) { described_class.new }
      it "returns false" do
        expect(empty_board).not_to be_full
      end
    end
    context "when the board is full" do
      let(:item) { instance_double(Item) }
      subject(:full_board) { described_class.new(Array.new(6) { Array.new(7) { item } }) }
      it "returns true" do
        expect(full_board).to be_full
      end
    end
  end

  describe "#save_move" do
    let(:item) { Item.new }
    subject(:board) { described_class.new([[nil], [nil], [nil], [nil]]) }
    it "changes the last nil to an Item instance" do
      expect { board.save_move(0, item) }.to change { board.instance_variable_get(:@board)[3][0].class }.to be(Item)
    end
  end

  describe "#valid_move?" do
    let(:item) { instance_double(Item) }
    context "when it is above bounds" do
      subject(:board) { described_class.new([[nil], [nil], [nil], [nil]]) }
      it "returns false" do
        expect(board.valid_move?(1)).to be(false)
      end
    end
    context "when the column is full" do
      subject(:board) { described_class.new([[item], [item], [item], [item]]) }
      it "returns false" do
        expect(board.valid_move?(0)).to be(false)
      end
    end
    context "when it is within bounds, and there is space" do
      subject(:board) { described_class.new([[nil], [nil], [nil], [nil]]) }
      it "returns true" do
        expect(board.valid_move?(0)).to be(true)
      end
    end
  end
end
