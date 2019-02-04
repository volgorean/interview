class Distance
  attr_accessor :from, :to, :dist

  def initialize(from, to)
    @from = from
    @to = to
    @dist = from.get_distance(to)
  end
end
