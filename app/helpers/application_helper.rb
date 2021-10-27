module ApplicationHelper
  def field_to_front(field)
    field.gsub('-', ' ').capitalize
  end
end
