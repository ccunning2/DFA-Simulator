class SetNode
	attr_accessor :p, :rank, :name

	def initialize(name)
		@p = self  #pointer to parent
		@rank = 0
		@name = name
	end

	def self.union(x,y)
		self.link(self.find_set(x),self.find_set(y))
	end

	def self.link(x ,y)
		if x.rank > y.rank
			y.p = x
		else
			x.p = y
			if x.rank == y.rank
				y.rank = y.rank + 1
			end
		end
	end

	def self.find_set(x)
		x.p = self.find_set(x.p) unless x == x.p
		return x.p
	end
end