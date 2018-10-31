module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json_data
    JSON.parse(response.body)["data"]
  end
end