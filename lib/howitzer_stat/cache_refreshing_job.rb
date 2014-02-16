module HowitzerStat
  class CacheRefreshingJob
    def initialize
      @stat = {}
    end

    def perform
      new_stat = gather_stat
      unless @stat == new_stat
        HowitzerStat::CucumberParser.new.run
        @stat = new_stat
      end
    end

    private
    def gather_stat
      Dir[File.join(HowitzerStat.settings.path_to_source, 'features', '**', '*.feature')].inject({}) do |res, f|
        res[f] = IO.read(f).hash
        res
      end
    end
  end
end