$redis_client = Redis.new(driver: :hiredis)

$redis = Redis::Namespace.new('evaluator', redis: $redis_client)