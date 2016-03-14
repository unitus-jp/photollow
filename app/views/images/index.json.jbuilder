json.array!(@images) do |image|
  json.extract! image, :id, :url, :page_id
  json.url image_url(image, format: :json)
end
