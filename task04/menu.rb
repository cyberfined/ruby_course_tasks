require_relative("menu_elem")

class Menu
  def initialize
    @elements = [MenuElem.new("Back", nil)]
  end

  def add_element(title, handler)
    @elements.insert(-2, MenuElem.new(title, handler))
  end

  def run(looped=true, &index_handler)
    loop do
      print_elements
      begin
        elem_index = Integer(gets.strip)-1
      rescue
        next
      end

      next if elem_index < 0 || elem_index >= @elements.length
      break if elem_index == @elements.length-1

      menu_elem = @elements[elem_index]
      if index_handler
        index_handler.call(elem_index)
      elsif menu_elem && menu_elem.handler
        menu_elem.handler.call
      end

      break unless looped
    end
  end

  private

  # Made it private because it's should be used only in run implementation.
  # User shouldn't neither be able to print menu elements nor have an
  # access to them.
  def print_elements
    @elements.each_with_index {|elem,i| puts "#{i+1}) #{elem.title}"}
  end
end
