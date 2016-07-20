json.array!(@teams) do |team|
  json.extract! team, :id, :name
end
