require "open-uri"

class GithubClient
  attr_reader :commits

  ROOT  = "http://github.com/api/v2/yaml"

  def initialize(user, repos)
    @user = user
    @repos = repos
    @commits = nil
    @objects = {}
  end

  def load_commits(path = nil)
    return @commits if @commits
    path = path.to_s
    path = path[1..-1] if path[0] == ?/ 
    uri = "#{ROOT}/commits/list/#{@user}/#{@repos}/master/#{path}"
    response = load_yaml(uri)
    @commits = response["commits"]
  end

  def tree_sha(commit_sha = nil, path = nil)
    load_commits(path)
    return @commits.first["tree"] unless commit_sha
    @commits.each do |commit|
      return commit["tree"] if commit["id"] == commit_sha
    end
    return nil
  end

  def tree(commit_sha = nil, path = nil)
    sha = tree_sha(commit_sha, path)
    return _tree(sha)
  end

  def _tree(sha)
    unless @objects[sha]
      uri = "#{ROOT}/tree/show/#{@user}/#{@repos}/#{sha}"
      response = load_yaml(uri)
      @objects[sha] = response["tree"]
    end
    return @objects[sha]
  end

  def commit(commit_sha = nil)
    unless @objects[commit_sha]
      uri = "#{ROOT}/commits/show/#{@user}/#{@repos}/#{commit_sha}"
      response = load_yaml(uri)
      @objects[commit_sha] = response["commit"]
    end
    return @objects[commit_sha]
  end

  def load_yaml(uri)
    return GithubClient.load_yaml(uri)
  end

  def blob(commit_sha, path)
    commit = commit(commit_sha)
    sha = commit["tree"]
    tree = _tree(sha)
    fname = path.split("/").last
    id = nil
    tree.each do |item|
      if item["fname"] == fname
        id = item["id"]
        break
      end
    end

    id = commit["id"]
    unless @objects[id]
      uri = "#{ROOT}/blob/show/#{@user}/#{@repos}/#{id}"
      open(uri) do |io|
        @objects[id] = io.read
      end
    end
    return @objects[id]
  end

  def self.load_yaml(uri)
    open(uri) do |io|
      src = io.read
      return YAML.load(src)
    end
  end
  private :load_yaml


  def self.search(key)
    return load_yaml("#{ROOT}/repos/search/#{URI.encode(key)}")["repositories"]
  end

end
