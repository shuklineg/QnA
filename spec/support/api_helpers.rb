module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    options[:params] = options[:params].to_json if options[:params] && method != :get
    send method, path, options
  end
end
