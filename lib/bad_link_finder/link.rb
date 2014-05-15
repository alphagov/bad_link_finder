require 'mechanize'
require 'openssl'

module BadLinkFinder
  class Link
    attr_reader :link, :url, :error_message, :exception

    def initialize(page_url, link, logger = BadLinkFinder::NullLogger.new)
      @logger = logger
      @page_url = page_url
      @link = link
      @url = get_url_from_link(link)

      verify_url(@url)
      validate_with_request

    rescue URI::InvalidURIError => exception
      record_error("This link is in a bad format", exception)
    rescue Mechanize::ResponseCodeError => exception
      if [405, 500].include?(exception.response_code.to_i)  && !@head_unsupported
        @head_unsupported = true
        retry
      else
        record_error("This request returned a #{exception.response_code}", exception)
      end
    rescue Mechanize::UnauthorizedError => exception
      record_error("This link requires authorisation", exception)
    rescue Mechanize::UnsupportedSchemeError => exception
      record_error("This link has a scheme we can't load (should be http or https)", exception)
    rescue Mechanize::RedirectLimitReachedError => exception
      record_error("This link might be in a redirect loop", exception)
    rescue Mechanize::RobotsDisallowedError => exception
      record_error("This link is blocked by robots.txt or nofollow attributes", exception)
    rescue Mechanize::Error, Net::HTTP::Persistent::Error, Timeout::Error, Errno::EINVAL,
           Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
           Net::ProtocolError, OpenSSL::SSL::SSLError, SocketError => exception # Thanks Net::HTTP
      record_error("The server failed to serve this page properly", exception)
    rescue Exception => exception
      record_error("Some other exception happened", exception)
    end

    def valid?
      @error_message.nil?
    end

  protected

    def validate_with_request
      @logger.info "-- testing link #{@link} using #{@url}"
      sleep 0.1 # Recommended pause for gov.uk rate limiting

      browser = Mechanize.new
      browser.user_agent = 'GOV.UK link checker'
      browser.keep_alive = false
      browser.history.max_size = 0
      browser.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      browser.agent.open_timeout = 15

      if @head_unsupported
        browser.get(@url)
      else
        browser.head(@url)
      end
    end

    def get_url_from_link(link)
      URI.join(@page_url, link).to_s
    end

    def verify_url(url)
      if url.start_with?('http')
        raise URI::InvalidURIError.new("The URL #{url} should start with http:// or https://") unless url =~ %r{^https?://}
      end
    end

    def record_error(message, exception = nil)
      @error_message = message
      @exception = exception

      @logger.info "---- found broken link #{@url}: #{message}: #{exception.message if exception}"
    end
  end
end
