module ApplicationHelper
  # Renders a uuid string in more human-readable format
  #
  # @return [String]
  #
  #
  # @example Shorten a uuid string to 10 characters with elipsis
  #   humanize_uuid(uuid: "1bc6865a-1c44-42c8-ab80-c27d22686dc9") #=> "1bc6865a..."
  def humanize_uuid(uuid:, length: 10, elipsis: true)
    formatted_string = uuid[0..(length - 1)]
    elipsis_string = elipsis ? "..." : ""
    "#{formatted_string}#{elipsis_string}"
  end
end
