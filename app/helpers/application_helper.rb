module ApplicationHelper
  def humanize_uuid(uuid_string, length = 10, elipsis = true)
    formatted_string = uuid_string[0..(length - 1)]
    elipsis_string = elipsis ? "..." : ""
    "#{formatted_string}#{elipsis_string}"
  end
end
