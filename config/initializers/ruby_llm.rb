RubyLLM.configure do |config|
  config.openai_api_key = ENV['GEMINI_API_KEY']
  config.openai_api_base = "gemini-flash-latest"
end
