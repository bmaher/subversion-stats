require 'open4'

class LogFetcher

  def initialize(repository_details)
    @repo = repository_details.symbolize_keys
  end

  def fetch
    command = "svn log --non-interactive #{username} #{password} #{@repo[:repository_url]} #{revisions} --verbose --xml"
    status = Open4::popen4(command) do |pid, stdin, stdout, stderr|
      @output = stdout.readlines.join
      @stderr = stderr.readlines.join.gsub("\n", '')
    end
    unless status == 0
      raise Errors::SvnError.new, "The error: [#@stderr] was raised by command: [#{command}]"
    end
    @output
  end

  def username
    if @repo[:username].blank?
      ''
    else
      "--username #{@repo[:username]}"
    end
  end

  def password
    if @repo[:password].blank?
      ''
    else
      "--password #{@repo[:password]}"
    end
  end

  def revisions
    if @repo[:revision_from].blank? && @repo[:revision_to].blank?
      ''
    elsif @repo[:revision_to].blank?
      if @repo[:revision_from] == 'HEAD'
        "-r#{@repo[:revision_from]}:0"
      else
        "-r#{@repo[:revision_from]}"
      end
    else
      "-r#{@repo[:revision_from]}:#{@repo[:revision_to]}"
    end
  end
end