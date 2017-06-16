# DFA-Simulator
A DFA (https://en.wikipedia.org/wiki/Deterministic_finite_automaton) simulator written in Ruby for a class project. 

Usage: Provide one or two descriptions of DFA's in the following format:
```        
  states:          qe; q0; q00; q000   
  input_alphabet:  0; 1
  start_state:     qe      
  accept_states:   qe; q0; q00  
  delta: qe,1   -> qe; q0,1   -> qe; q00,1  -> qe; q000,1 -> qe; qe,0  -> q0; q0,0  -> q00; q00,0 -> q000; q000,0 -> q000
```
Above is an example of what the text file representation of the DFA should look like. See the Example_DFAs folder for more examples. 

### To see if a provided DFA reaches an accept state: 
`./test.rb your_DFA.dfa`

### To see if two DFA's are equivalent (and if not, show a counterexample string):
`./test.rv first.dfa second.dfa`


#### For a description of the algorithm used, citations, etc, see report.pdf
