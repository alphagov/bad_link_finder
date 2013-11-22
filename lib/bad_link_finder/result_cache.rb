# If/when the bad link finder is converted to a set of parallel processes
# this cache will need to be backed by something threadsafe.

module BadLinkFinder
  class ResultCache
    def initialize
      @cache = {}
    end

    def store(key, link)
      @cache[stripped_key(key)] = link
    end

    def fetch(key)
      @cache[stripped_key(key)]
    end

  protected

    def stripped_key(key)
      key.sub(/#.*$/, '')
    end
  end
end
