token = JSON.parse(content)['token']
to_queue = page['vars']['to_queue']

pages << {
    url: "https://services.rappi.com.ar/api/rocket/v2/guest",
    page_type: 'get_auth_header',
    method: 'POST',
    body: "{}",
    driver: {'name' => "#{to_queue['page_type']}_#{to_queue['url']}"},
    priority: 101,
    headers: {
        "user-agent"=> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome",
        "accept"=> "*/*",
        "accept-encoding"=> "gzip, deflate, br",
        "deviceid" => page['headers']['deviceid'],
        "content-type" => "application/json",
        "x-guest-api-key" => token,
        "origin" => "https://www.rappi.com.ar/",
        "referer" => "https://www.rappi.com.ar/",
    },
    vars: {
        to_queue: to_queue,
    }
}
