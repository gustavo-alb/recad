json.array!(@locals) do |local|
  json.extract! local, :id
  json.url local_url(local, format: :json)
end
