class FloatData
  attr_accessor :ptr
  
  def initialize(data)
    @num_vertices = data.count
    @ptr = Pointer.new(:float, @num_vertices)
    set_data(data)
  end
  
  def set_data(vertices)
    vertices.each_with_index do |vertex,idx|
      @ptr[idx] = vertex
    end
  end  
  
  def size
    @num_vertices
  end
end
