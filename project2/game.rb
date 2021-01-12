require 'gosu'

load 'ai.rb'
load 'deck.rb'

class Game < Gosu::Window
  IMAGE_PATH = "images/"
  SOUND_PATH = "sounds/"

  SCREEN_WIDTH, SCREEN_HEIGHT = 1600, 900
  REFERENCCE_IMAGE = Gosu::Image.new(IMAGE_PATH + "cards/DB11.png");
  CARD_WIDTH, CARD_HEIGHT = REFERENCCE_IMAGE.width, REFERENCCE_IMAGE.height

  PAUSE_X, PAUSE_Y = 1435, 30
  NEW_GAME_X, NEW_GAME_Y = 1515, 30
  PLUS_THREE_X, PLUS_THREE_Y = 1490, 128

  @@x_buf, @@y_buf = 20, 20
  @@score = Array.new
  (0..7).each { |i| @@score.push Gosu::Image.new(IMAGE_PATH + "scores/score" + i.to_s + ".png") }

  def initialize
    super SCREEN_WIDTH, SCREEN_HEIGHT
    self.caption = "Set"

    setup_new_game

    @background = Gosu::Image.new(IMAGE_PATH + "Background.png")
    @header = Gosu::Image.new(IMAGE_PATH + "Header.png")
    @player_background = Gosu::Image.new(IMAGE_PATH + "PlayerBackground.png")
    @ai_background = Gosu::Image.new(IMAGE_PATH + "AIBackground.png")

    @paused = false
    @pause = Gosu::Image.new(IMAGE_PATH + "Pause.png")
    @hover_pause = Gosu::Image.new(IMAGE_PATH + "HoverPause.png")
    @play = Gosu::Image.new(IMAGE_PATH + "Play.png")
    @hover_play = Gosu::Image.new(IMAGE_PATH + "HoverPlay.png")

    @new_game = Gosu::Image.new(IMAGE_PATH + "NewGame.png")
    @hover_new_game = Gosu::Image.new(IMAGE_PATH + "HoverNewGame.png")

    @plus_three = Gosu::Image.new(IMAGE_PATH + "Plus3.png")
    @hover_plus_three = Gosu::Image.new(IMAGE_PATH + "HoverPlus3.png")

    @hover_card = Gosu::Image.new(IMAGE_PATH + "CardHoverOver.png")
    @player_select = Gosu::Image.new(IMAGE_PATH + "PlayerSelect.png")
    @hover_player_select = Gosu::Image.new(IMAGE_PATH + "HoverPlayerSelect.png")

    @set_fail = Gosu::Sample.new(SOUND_PATH + "Fail.wav")
    @set_complete = Gosu::Sample.new(SOUND_PATH + "Set.wav")
    @select1 = Gosu::Sample.new(SOUND_PATH + "Select1.wav")
    @select2 = Gosu::Sample.new(SOUND_PATH + "Select2.wav")
    @general_select = Gosu::Sample.new(SOUND_PATH + "GeneralSelect.wav")
    @ai_set = Gosu::Sample.new(SOUND_PATH + "AISet.wav")
  end

  # Creates a new game
  def setup_new_game
    @player_cards = Array.new
    @player_score = 0

    @ai = AI.new

    @deck = Deck.new

    @cards = @deck.draw_cards! 12
    @card_images = Array.new
    update_card_images
  end

  # Redefines the method in order to enable to cursor
  def needs_cursor?
    true
  end

  # Updates card images to match the model
  def update_card_images
    @card_images = Array.new
    for i in 0...@cards.count do
      card = @cards[i]
      @card_images.push Gosu::Image.new(IMAGE_PATH + "cards/" + card[0] + card[2] + card[3].to_s + card[1].to_s + ".png")
    end
  end
  
  # Updates the AI player
  def update
    if (!@paused && @ai.get_score < 7 && @player_score < 7)
      ai_set = @ai.update @cards
      if (ai_set.count != 0)
        draw_replacement_cards ai_set
        @ai_set.play
        @ai.score_set
      end
    end
  end

  # Handles all mouse clicks
  def button_down(id)
    # Checks if we are starting a new game
    if self.mouse_x >= NEW_GAME_X and self.mouse_x <= NEW_GAME_X + @new_game.width and self.mouse_y >= NEW_GAME_Y and self.mouse_y <= NEW_GAME_Y + @new_game.height
        @general_select.play 0.6
        setup_new_game
    end

    # Checks if we are pausing/unpausing the game
    if self.mouse_x >= PAUSE_X and self.mouse_x <= PAUSE_X + @pause.width and self.mouse_y >= PAUSE_Y and self.mouse_y <= PAUSE_Y + @pause.height
        @general_select.play 0.6
        @paused = !@paused
    end

    if !@paused && @ai.get_score < 7 && @player_score < 7
      # Checks if we are adding three more cards
      if self.mouse_x >= PLUS_THREE_X and self.mouse_x <= PLUS_THREE_X + @plus_three.width and self.mouse_y >= PLUS_THREE_Y and self.mouse_y <= PLUS_THREE_Y + @plus_three.height
        if @cards.count < 21
          @general_select.play 0.6
          @cards.concat @deck.draw_cards! 3
          update_card_images
        else
          @set_fail.play
        end
      end

      # Checks if a card was selected
      for y in 0...3 do
        for x in 0...(@cards.count / 3) do
          card = @cards[y * (@cards.count / 3) + x]
          card_x = get_card_x(x)
          card_y = get_card_y(y)

          if self.mouse_x >= card_x and self.mouse_x <= card_x + CARD_WIDTH and self.mouse_y >= card_y and self.mouse_y <= card_y + CARD_HEIGHT
            if @player_cards.include? card
              if @player_cards.count == 1
                @select1.play 0.5
              elsif @player_cards.count == 2
                @select2.play 0.5
              end
              @player_cards.delete card
            else
              @player_cards.push card
              if @player_cards.count == 1
                @select1.play 0.5
              elsif @player_cards.count == 2
                @select2.play 0.5
              end
            end

            if @player_cards.count == 3
              if Deck.is_set? @player_cards[0], @player_cards[1], @player_cards[2]
                @player_score += 1
                @set_complete.play
                draw_replacement_cards @player_cards
              else
                @set_fail.play
              end
              @player_cards.clear
            end
          end
        end
      end
    end

  end

  def draw_replacement_cards cards
    if @cards.count > 12
      for i in 0..2 do
        @cards.delete cards[i]
      end
    else
      for i in 0..2 do
        index = @cards.index cards[i]
        card = (@deck.draw_cards! 1)[0]
        @cards[index] = card
      end
    end

    update_card_images

    @player_cards.clear
    @ai.setup_timer
  end
  
  # Draws everything on the screen
  def draw
    # Draw Background and Panes
    @background.draw(0, 0, 0)
    @header.draw(0, 0, 1)
    @player_background.draw(0, SCREEN_HEIGHT - @player_background.height, 1)
    @ai_background.draw(SCREEN_WIDTH / 2, SCREEN_HEIGHT - @ai_background.height, 1)


    # GUI Details and Buttons
    if !@paused
      pause = @pause
      if self.mouse_x >= PAUSE_X and self.mouse_x <= PAUSE_X + @pause.width and self.mouse_y >= PAUSE_Y and self.mouse_y <= PAUSE_Y + @pause.height
        pause = @hover_pause
      end
      pause.draw(PAUSE_X, PAUSE_Y, 2)
    else
      play = @play
      if self.mouse_x >= PAUSE_X and self.mouse_x <= PAUSE_X + @play.width and self.mouse_y >= PAUSE_Y and self.mouse_y <= PAUSE_Y + @play.height
        play = @hover_play
      end
      play.draw(PAUSE_X, PAUSE_Y, 2)
    end

    new_game = @new_game
    if self.mouse_x >= NEW_GAME_X and self.mouse_x <= NEW_GAME_X + @new_game.width and self.mouse_y >= NEW_GAME_Y and self.mouse_y <= NEW_GAME_Y + @new_game.height
      new_game = @hover_new_game
    end
    new_game.draw(NEW_GAME_X, NEW_GAME_Y, 2)

    plus_three = @plus_three
    if self.mouse_x >= PLUS_THREE_X and self.mouse_x <= PLUS_THREE_X + @plus_three.width and self.mouse_y >= PLUS_THREE_Y and self.mouse_y <= PLUS_THREE_Y + @plus_three.height
      plus_three = @hover_plus_three
    end
    plus_three.draw(PLUS_THREE_X, PLUS_THREE_Y, 2)

    score_y = 755;
    @@score[@player_score].draw(470, score_y, 2)
    @@score[@ai.get_score].draw(970, score_y, 2)


    # Draw Cards
    hover_x_dif, hover_y_dif = (@hover_card.width - CARD_WIDTH) / 2, (@hover_card.height - CARD_HEIGHT) / 2

    for y in 0...3 do
      for x in 0...(@cards.count / 3) do
        image = @card_images[y * (@cards.count / 3) + x]

        card_x = get_card_x(x)
        card_y = get_card_y(y)

        # Highlights the card if it is selected or moused over
        selected = @player_cards.include? @cards[y * (@cards.count / 3) + x]
        hovered = self.mouse_x >= card_x && self.mouse_x <= card_x + CARD_WIDTH && self.mouse_y >= card_y && self.mouse_y <= card_y + CARD_HEIGHT
        
        if selected && hovered
          @hover_player_select.draw(card_x - hover_x_dif, card_y - hover_y_dif, 2)
        elsif selected
          @player_select.draw(card_x - hover_x_dif, card_y - hover_y_dif, 2)
        elsif hovered
          @hover_card.draw(card_x - hover_x_dif, card_y - hover_y_dif, 2)
        end

        image.draw(card_x, card_y, 3)
      end
    end
  end

  # Helper method to allow for single point of control
  def get_x_start
    (SCREEN_WIDTH - ((CARD_WIDTH + @@x_buf) * (@cards.count / 3) - @@x_buf)) / 2
  end

  # Helper method to allow for single point of control
  def get_y_start
    200
  end

  # Helper method to allow for single point of control
  def get_card_x (x_pos)
    (CARD_WIDTH + @@x_buf) * x_pos + get_x_start
  end

  # Helper method to allow for single point of control
  def get_card_y (y_pos)
    (CARD_HEIGHT + @@y_buf) * y_pos + get_y_start
  end

end

Game.new.show