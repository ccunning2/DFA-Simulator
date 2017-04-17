require_relative 'setnode.rb'

class DFA
	attr_accessor :states, :input_alphabet, :start_state, :accept_states, :delta, :current_state
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

	def self.equivalent?(m1, m2)
		if m1.input_alphabet != m2.input_alphabet
			return false
		end
		#stores the set-node for all the states, identified by #{machine}#{state}
		states = {}
		#First build a node for every state in m1 and m2
		m1.states.each do |state|
			states["m1#{state}"] = SetNode.new(state)
		end

		m2.states.each do |state|
			states["m2#{state}"] = SetNode.new(state)
		end

		queue = [] #Can replicate queue behavior using push/shift
		#Begin with the start states
		p0 = m1.start_state
		p1 = m2.start_state

		p0_accept = m1.accept_states.include? p0
		p1_accept = m2.accept_states.include? p1

		if p0_accept == p1_accept
			SetNode.union(states["m1#{p0}"], states["m2#{p1}"])
			queue.push states["m1#{p0}"]
			queue.push states["m2#{p1}"]
		else
			return "Not equivalent, epsilon"
		end
		
		witness_map = {}

		until queue.empty? do
			#q1 should always be m1; q2 -> m2
			q1 = queue.shift #From m1
			q2 = queue.shift #From m2
			
			m1.input_alphabet.each do |a|
				p = states["m1#{m1.delta["#{q1.name},#{a}"]}"]
				q = states["m2#{m2.delta["#{q2.name},#{a}"]}"]# End (i)

				r1 = SetNode.find_set(p)
				r2 = SetNode.find_set(q)

				if r1 != r2
					binding.pry
					SetNode.union(r1, r2)
					queue.push p #From m1
					queue.push q #From m2
					witness_map["#{p.name},#{q.name}"] = "#{q1.name},#{q2.name},#{a}"

					p_accept = m1.accept_states.include? p.name
					q_accept = m2.accept_states.include? q.name

					if p_accept == q_accept
						continue
					else
						#Need to create witness string
						witness = ""
						key = "#{p.name},#{q.name}"
						until key == "#{m1.start_state},#{m2.start_state}" do
							witness_part = witness_map[key]
							witness_components = witness_part.split ","
							witness = "#{witness_components[2]}#{witness}"
							key = "#{witness_components[0]},#{witness_components[1]}"
						end
						return "DFA's not equivalent, witness:#{witness}"
					end
				end
				
			end #End input alphabet each
		end
		return "The DFA's are equivalent"
	end
end