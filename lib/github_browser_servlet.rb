require "erb"

class GithubBrowserServlet < WEBrick::HTTPServlet::AbstractServlet
  include ERB::Util

  MOUNT = "/github/"
  TEMPLATES_DIR = File.dirname(__FILE__) + "/templates"

  def do_GET(req, res)
    @req = req
    @res = res
    routes(req.request_uri)
  end

  def routes(uri)
    path = uri.path
    raise "Illegal uri #{uri.to_s}" unless path[0,MOUNT.length] == MOUNT
    path = path[MOUNT.length..-1]
    token = path.split("/")

    @user    = token[0]
    @repos   = token[1]
    @command = token[2]
    @sha     = token[3]
    @path    = "/" + token[4..-1].to_a.join("/")

    if !@user
      search_projects
    elsif !@repos
      search_projects
    elsif !@command
      tree
    elsif @command == "tree"
      tree
    elsif @command == "commit"
      commit
    elsif @command == "blob"
      blob
    end
  end

  def search_projects
    result = GithubClient.search("hatenadiary #{@user}")
    result.sort! do |a,b| 
      c = a["username"] <=> b["username"] 
      c == 0 ? a["name"] <=> b["name"] : c
    end
    @res.body = template(:search).result(binding)
  end

  def tree
    @c ||= GithubClient.new(@user, @repos)
    tree = @c.tree(@sha)
    commits = @c.commits
    if @sha
      current = commits.find {|item| item["id"] == @sha }
    else
      current = commits.first
    end
    (prev_link, next_link) = navi_links(commits, current)
    @res.body = template(:tree).result(binding)
  end

  def commit
    @c ||= GithubClient.new(@user, @repos)
    commits = @c.load_commits
    current = @c.commit(@sha)
    (prev_link, next_link) = navi_links(commits, current)
    @res.body = template(:commit).result(binding)
  end

  def blob
    unless @path =~ %r{/(\d{4}-\d{2}-\d{2})(?:-.+)?\.txt$}
      raise "Not implemented yet." # TODO redirect to github
    end
    date = Time.parse($1)

    @c ||= GithubClient.new(@user, @repos)
    commits = @c.load_commits(@path) #FIXME This works only at root tree.
    current = @c.commit(@sha)
    bloob = @c.blob(current["tree"], @path)
    (title,body) = hatena_entry(bloob["data"])
    (prev_link, next_link) = navi_links(commits, current)
    @res.body = template(:blob).result(binding)
  end

  def hatena_entry(src)
    (title, body) = src.split(/\r\n|\r|\n/, 2)
    parser = Text::Hatena.new
    parser.parse(body)
    body = parser.html
    return [title, body]
  end

  def template(name)
    ERB.new(File.read(TEMPLATES_DIR + "/#{name.to_s}.erb"), nil, "%-")
  end

  def navi_links(commits, current)
    result = [nil, nil]
    commits.each_with_index do |com, i|
      if com["id"] == current["id"]
        result[1] = commits[i - 1]["id"] if 0 < i
        result[0] = commits[i + 1]["id"] if i < commits.length - 1
      end
    end
    return result
  end

end
