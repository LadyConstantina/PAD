import memcache

cache = memcache.Client(['localhost:4012'])

def get_data_from_cache(user_id, request):
    
    key = f"{request} for {user_id}"
    data = cache.get(key)
    
    return data

def save_data_in_cache(user_id,request,data):
    key = f"{request} for {user_id}"
    cache.set(key, data, time=300)
    

if __name__ == '__main__':
    # Example usage
    key = "example_key"
    cached_data = get_data_from_cache(key)
    print(cached_data)
