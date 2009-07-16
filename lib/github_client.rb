require "open-uri"

class GithubClient
  attr_reader :commits

  ROOT = "http://github.com/api/v2/yaml"

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

  def blob(tree_sha, fname)
    unless @objects[tree_sha + fname]
      uri = "#{ROOT}/blob/show/#{@user}/#{@repos}/#{tree_sha}/#{fname}"
      response = load_yaml(uri)
      response = response["blob"]
      @objects[response["sha"]] = @objects[tree_sha + fname] = response
    end
    return @objects[tree_sha + fname]
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
