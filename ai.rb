load 'deck.rb'

class AI
	def initialize
		@score = 0
		@generator = Random.new
		@set = Array.new
		setup_timer
	end

	def setup_timer
		@time = (Time.now.to_f).to_i
		@time_goal = @generator.rand(5.0..18.0)
	end
	
	def update cards
		# Reset the timer in the case of a long pause
		if (Time.now.to_f).to_i - @time >= @time_goal + 0.5
			setup_timer
		end

		if (Time.now.to_f).to_i - @time >= @time_goal
			i, j, k = 0, 0, 0
			while i < cards.count
				j = i + 1
				while j < cards.count
					k = j + 1
					while k < cards.count
						if Deck.is_set? cards[i], cards[j], cards[k]
							@set.push cards[i]
							@set.push cards[j]
							@set.push cards[k]
							i, j, k = cards.count, cards.count, cards.count
						end
						k += 1
					end
					j += 1
				end
				i += 1
			end
			setup_timer
		end

		@set
	end

	def score_set
		@set.clear
		@score += 1
	end

	def get_score
		@score
	end
end