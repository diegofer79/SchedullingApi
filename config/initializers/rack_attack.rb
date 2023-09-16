if !ENV['REDIS_URL'] || Rails.env.test?
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
end

Rack::Attack.throttle("*", limit: 600, period: 1.minute) do |req|
  req.ip
end