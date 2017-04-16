class DFA
	@states = []
	@input_alphabet = []
	@start_state = nil
	@accept_states = []
	@delta = {}
	@current_state = nil

	def initialize(states, input_alphabet, start_state, accept_states, delta)
		@states = states
		@input_alphabet = input_alphabet
		@start_state = start_state
		@accept_states = accept_states
		@delta = delta
		@current_state = start_state 
		#Might want to sort all of these
		@input_alphabet.sort!
	end

	def run(s)
		if s == ""
			return @accept_states.include? @current_state	
		end
		s.each_char { |c|
			transition = "#{@current_state},#{c}"
			if @delta[transition].nil?
				return false
			else
				@current_state = @delta[transition]
			end
		}
		@accept_states.include? @current_state	
	end
end