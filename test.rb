#!/usr/bin/env ruby
require 'pry'
require_relative 'DFA.rb'


current = nil

#Below method is deprecated
# def push_data(data)
# 	data.strip!
# 	datalist = data.split ';'
# 	datalist.each do |dat|
# 		dat.strip!
# 		case $current
# 		when "states"
# 			states.push(dat)
# 		when "input_alphabet"
# 			input_alphabet.push(dat)
# 		when "start_state"
# 			start_state = dat
# 		when "accept_states"
# 			accept_states.push(dat)
# 		when "delta"
# 			dat = dat.split "->"
# 			delta["#{dat[0].strip}"] = "#{dat[1].strip}"
# 			puts "This is the data #{dat}"
# 		else
# 			puts "#{$current} not supported yet."
# 		end
# 	end
# binding.pry
# end 

def parse_dfa(file)
	delta = {}
	states = []
	input_alphabet = []
	start_state = nil
	accept_states = []
	data = nil
	current = ""
	IO.foreach(file) { |line|
		a = line.sub(/#.*/, '').chomp #First eliminate comments
		if a.include? ':'
			line_array = a.split ':'
			current = line_array[0]
			data = line_array[1] unless line_array[1].nil?
		end	

		if not data.nil? 
			data.strip!
			datalist = data.split ';'
			datalist.each { |dat|
				dat.strip!
				case current
				when "states"
					states.push(dat)
				when "input_alphabet"
					input_alphabet.push(dat)
				when "start_state"
					start_state = dat
				when "accept_states"
					accept_states.push(dat)
				when "delta"
					dat = dat.split "->"
					delta["#{dat[0].strip}"] = "#{dat[1].strip}"
				else
					puts "#{current} not supported yet."
				end
			}
			data = nil #Reset
		end
	}
	return DFA.new(states, input_alphabet, start_state,accept_states,delta)
end

binding.pry
args = {}
compare = false
s = ""

args[1] = ARGV[0] unless ARGV[0].nil?
args[2] = ARGV[1] unless ARGV[1].nil?

dfa_re = /\w+.dfa/

if args.nil? || dfa_re.match(args[1]).nil?
	puts "Invalid input!"
end

if !dfa_re.match(args[2]).nil?
	if !File.exist? args[2]
		raise "File #{args[2]} not found"
	else
		compare = true
	end
end

if !File.exist? args[1]
	raise "File #{args[1]} not found"
end

m1 = parse_dfa(args[1]) unless args[1].nil?

if !args[2].nil?
	if compare
		m2 = parse_dfa(args[2]) unless args[2].nil?
		puts DFA.equivalent?(m1, m2)
	else
		s = args[2]
		accept = m1.run(s)
		puts accept
	end
end

