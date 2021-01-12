class Deck
  def initialize()
  # creation of the deck
    @deck = Array.new

    shapes = ['D', 'H', 'S']
    num_of_shapes = [1, 2, 3]
    colors = ['B', 'R', 'Y']
    shadings = [1, 2, 3]

    shapes.each { |shape|
      num_of_shapes.each { |num|
        colors.each { |color|
          shadings.each { |shade|
            @deck.push [shape, num, color, shade]
          }
        }
      }
    }
  end

  # this method will return the indices of "num" cards
  # these indices will be removed from the inputted array
  # inputted array must have size greater or equal to num
  def draw_cards!(num)
    @deck.shuffle!
    i = 0
    cards = []
    while i < num
      cards.push @deck.pop
      i += 1
    end
    cards #returning
  end

  # input will be 3 arrays of size four that each represent a card
  # returns true if 3 cards are a proper set
  # false otherwise
  def self.is_set?(a, b, c)
    set = true
    count = 0
    while set && count < 4
      unless ((a[count] == b[count]) && (a[count] == c[count])) || ((a[count] != b[count]) && (a[count] != c[count]) && (b[count] != c[count]))
        set = false
      end
      count += 1
    end
    set #Returning
  end
end