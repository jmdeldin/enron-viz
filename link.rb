class Link
  attr_reader :src, :dest, :extra

  def initialize(src, dest, extra = {})
    @src = src
    @dest = dest
    @extra = extra
  end

  def ==(o)
    return false unless o.is_a? self.class

    self.instance_variables.each do |v|
      return false if self.instance_variable_get(v) != o.instance_variable_get(v)
    end
    true
    end

  # True if the other object is the same instance and all of the
  # object's instance variables are equal.
  #
  def eql?(o)
    if o.instance_of? self.class
      self.instance_variables.each do |v|
        return false if self.instance_variable_get(v) != o.instance_variable_get(v)
      end
      true
    else
      false
    end
  end

  # Hash codes from /Effective Java/ via /The Ruby Programming Language/.
  #
  def hash
    code = 17
    code = 37 * code
    self.instance_variables.each do |v|
      code += self.instance_variable_get(v).hash
    end
    code
  end
end

