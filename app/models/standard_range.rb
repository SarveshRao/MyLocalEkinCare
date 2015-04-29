class StandardRange < ActiveRecord::Base
  belongs_to :test_component
  COLORS = ['btn-danger', 'btn-success', 'btn-warning', 'btn-danger', 'btn-danger']

  def colorize_ranges ranges
    return if ranges.nil?
    ranges.each_with_index.map{ |range, index| html_wrapper(range, index)}
  end

  def html_wrapper range, index
    "<a class='#{COLORS[index]} label'>#{range}</a><br/>" if !range.strip.empty?
  end
end
