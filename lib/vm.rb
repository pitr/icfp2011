class SKIException < StandardError; end

class Slot
  @@proponent = []
  @@opponent = []
  attr_accessor :f, :vitality
  def initialize
    @f = :i
    @vitality = 10000
  end
  class << self
    def proponent(i=nil)
      i.nil? ? @@proponent : (@@proponent[i] ||= Slot.new)
    end
    def opponent(i=nil)
      i.nil? ? @@opponent : (@@opponent[i] ||= Slot.new)
    end
  end
  def to_s; "{#{self.vitality}, #{self.f}}"; end
  def inspect; self.to_s; end

  def dead?; self.vitality < 1; end
  def is_int?; self.f.is_a? Fixnum; end

  def _succ
    raise SKIException.new unless self.is_int?
    self.f = [65535, self.f+1].min
  end
  def _dbl
    raise SKIException.new unless self.is_int?
    self.f = [65535, self.f*2].min
  end
  # more....
end
