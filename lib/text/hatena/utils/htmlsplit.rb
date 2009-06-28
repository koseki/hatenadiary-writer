class HTMLSplit
=begin Start of Document
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>htmlsplit.rb</title>
<link href="rubydoc.css" rel="stylesheet">
</head>
<body>
| <a href="./">���</a> |
<h1>HTML Split Library</h1>
<p> HTML���ɤ߽񤭤��롣 �ɤ߹����ʸ��ϥ�����ʸ���������ˤʤ롣 to_s�᥽�åɤ�HTML���᤹���Ȥ�����롣</p>
<h2>���饹����</h2>
<table bgcolor="#FFFFFF" border="1">
  <tr><td><a href="#HTMLSplit">HTMLSplit</a><td>HTML�򥿥���ʸ���ǡ�����ʬ�䤹�롣 
<tr>
	<td><a href="#CharacterData">CharacterData</a>
	<td>ʸ���ǡ���
  <tr><td><a href="#EmptyElementTag">EmptyElementTag</a>
	<td>�����ǤΥ���
  <tr>
	<td><a href="#StartTag">StartTag</a>
	<td>���ϥ���
  <tr>
	<td><a href="#EndTag">EndTag</a>
	<td>��λ����
  <tr>
	<td><a href="#Comment">Comment</a>
	<td>������
  <tr>
	<td><a href="#Declaration">Declaration</a>
	<td>���(DOCTYPE)
  <tr>
	<td><a href="#SSI">SSI</a>
	<td>SSI��
  <tr>
	<td><a href="#ERuby">ERuby</a>
	<td>eRuby/ASP/JSP������ץȢ�
  <tr>
	<td><a href="#PHP">PHP</a>
	<td>PHP������ץȢ�
  </table>
��������°���ͤʤɤ������ޤ줿������ץȤ�ǧ���Ǥ��ޤ���
<h2>�Ȥ��� </h2>
<h3>�ɤ߹���</h3>
<pre class="Exception"><samp>#!/usr/bin/ruby
require "htmlsplit"

obj = HTMlSplit.new(ARGF.read)</samp></pre>
<h3>����</h3>
<pre>
obj.document.each {|e|
    print e.to_s
}
</pre>
<h3>°��������</h3>
<pre>
img = Tag('img/')
img['src']='xxx.png'  #&lt;img src="xxx.png"&gt;

o = Tag('option')
o['selected']=true    #&lt;option selected&gt;
</pre>
=end

require "cgi"
require "kconv"

=begin OrderedHash
<h2><a href="OrderedHash">OrderedHash</a></h2>
<p>���֤���¸����ϥå���</p>
<p>���Υ��饹��<URL:http://rubyist.g.hatena.ne.jp/secondlife/20060519/1148046815>�μ������ˤ��Ƥ��ޤ���</p>
=end
class OrderedHash
  include Enumerable

  def initialize
    @keys = []
    @values = []
  end
  attr_accessor :keys, :values

  def []=(key, value)
    if index = keys.index(key)
      values[index] = value
    else
      keys << key
      values << value
    end
  end

  def [](key)
    if index = @keys.index(key)
      values[index]
    else
      nil
    end
  end

  def each
    @keys.each do |key|
      yield key, self[key]
    end
    self
  end

  def clear
    @keys.clear
    @values.clear
    self
  end

  def replace(other)
    clear
    other.each do |k, v|
      self[k] = v
    end
  end
end

=begin EmptyElementTag
 
<h2><a name="EmptyElementTag">EmptyElementTag</a></h2>
�����ǤΥ��� 
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">name</var>[,<var class="Hash">attr</var>])
  <dd>���������֥������Ȥ��������롣 <var class="String">name</var>�ϥ�����̾�� <var class="Hash">attr</var>�ϥ�����°��nil�ޤ���Hash
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">name
  <dd>����̾���֤���
  <dt class="Hash">attr 
  <dd>°�����֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
  <dt class="String">self[<var class="String">key</var>]
  <dd>key�˴�Ϣ�Ť���줿°���ͤ��֤��ޤ���
      �������륭������Ͽ����Ƥ��ʤ����ˤϡ�nil���֤��ޤ���
  <dt class="String">self[<var class="String">key</var>]= <var class="String">value</var>
  <dd><var class="String">key</var>���Ф���<var class="String">value</var>���Ϣ�Ť��ޤ���
      <var class="String">value</var>��nil�λ���<var class="String">key</var>���Ф����Ϣ��������ޤ���
</dl>
=end
class EmptyElementTag
	def initialize(name,attr=nil)
		@name = name.downcase
		@attr = attr
	end
	attr_accessor :name
	attr_accessor :attr
	def to_s
		if @attr
			"<"+@name+@attr.keys.collect{|n|
				v = @attr[n]
				if v==true
					' ' + n
				else
					' ' + n + '="' + CGI::escapeHTML(v) + '"'
				end
			}.to_s+">"
		else
			"<#{@name}>"
		end
	end
	def [](key)
		attr and attr[key]
	end
	def []=(key,value)
		if attr
			attr[key]=value
		else
			attr = value and OrderedHash.new.replace({key=>value})
		end
	end
end
=begin StartTag
<h2>StartTag</h2>
���ϥ���
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">name</var>[,<var class="Hash">attr</var>])
  <dd>���������֥������Ȥ��������롣 <var class="String">name</var>�ϥ�����̾�� <var class="Hash">attr</var>�ϥ�����°��nil�ޤ���Hash
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">name
  <dd>����̾���֤���
  <dt class="Hash">attr 
  <dd>°�����֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
  <dt class="String">self[<var class="String">key</var>]
  <dd>key�˴�Ϣ�Ť���줿°���ͤ��֤��ޤ���
      �������륭������Ͽ����Ƥ��ʤ����ˤϡ�nil���֤��ޤ���
  <dt class="String">self[<var class="String">key</var>]= <var class="String">value</var>
  <dd><var class="String">key</var>���Ф���<var class="String">value</var>���Ϣ�Ť��ޤ���
      <var class="String">value</var>��nil�λ���<var class="String">key</var>���Ф����Ϣ��������ޤ���
</dl>
=end
class StartTag
	attr_accessor :name
	attr_accessor :attr
	def initialize(name,attr=nil)
		@name = name.downcase
		@attr = attr
	end
	def to_s
		if @attr
			"<"+@name+@attr.keys.collect{|n|
				v = @attr[n]
				if v==true
					' ' + n
				else
					' ' + n + '="' + CGI::escapeHTML(v) + '"'
				end
			}.to_s+">"
		else
			"<#{@name}>"
		end
	end
	def [](key)
		attr and attr[key]
	end
	def []=(key,value)
		if attr
			attr[key]=value
		else
			attr = value and OrderedHash.new.replace({key=>value})
		end
	end
end
=begin EndTag
<h2>EndTag</h2>
��λ����
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">name</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">name</var>�ϥ�����̾��
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">name 
  <dd>����̾���֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
</dl>
=end
class EndTag
	def initialize(name)
		@name = name.downcase
	end
	attr_accessor :name
	def to_s
		"</#{@name}>"
	end
end
=begin CharacterData
<h2>CharacterData</h2>
ʸ���ǡ���
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">text</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">text</var>�ϥƥ�����
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">text 
  <dd>�ƥ����Ȥ��֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
</dl>
=end
class CharacterData
	def initialize(text)
		@text = text
	end
	attr_accessor :text
	def to_s
		@text
	end
end
=begin Declaraion
<h2>Declaraion</h2>
SGML���
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">text</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">text</var>�ϥƥ�����
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">text 
  <dd>�ƥ����Ȥ��֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
</dl>
=end
class Declaration
	def initialize(text)
		@text = text
	end
	attr_accessor :text
	def to_s
		"<!#{@text}>"
	end
end
=begin Comment
<h2>Comment</h2>
������
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">text</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">text</var>�ϥƥ�����
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">text 
  <dd>�ƥ����Ȥ��֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
</dl>
=end
class Comment
	def initialize(text)
		@text = text
	end
	attr_accessor :text
	def to_s
		"<!--#{@text}-->"
	end
end
=begin SSI
<h2>SSI</h2>
SSI
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">text</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">text</var>�ϥƥ�����
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">text 
  <dd>�ƥ����Ȥ��֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
</dl>
=end
class SSI
	def initialize(text)
		@text = text
	end
	attr_accessor :text
	def to_s
		"<!--#{@text}-->"
	end
end
=begin ERuby
<h2>ERuby</h2>
eRuby/ASP/JSP������ץ�
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">text</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">text</var>�ϥƥ�����
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">text 
  <dd>�ƥ����Ȥ��֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
</dl>
=end
class ERuby
	def initialize(text)
		@text = text
	end
	attr_accessor :text
	def to_s
		"<%#{@text}%>"
	end
end
=begin PHP
<h2>PHP</h2>
PHP������ץ�
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">text</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">text</var>�ϥƥ�����
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="String">text 
  <dd>�ƥ����Ȥ��֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
</dl>
=end
class PHP
	attr_accessor :text
	def initialize(text)
		@text = text
	end
	def to_s
		"<?#{@text}?>"
	end
end
=begin HTMLSplit
 
<h2><a name="HTMLSplit">HTMLSplit</a></h2>
HTML�ɤ߽� 
<h3>���饹�᥽�å�</h3>
<dl compact>
  <dt>new(<var class="String">html</var>)
  <dd>���������֥������Ȥ��������롣 <var class="String">html</var>��HTMLʸ��
</dl>
<h3>�᥽�å�</h3>
<dl compact>
  <dt class="Array">document 
  <dd>�ɥ�����Ȥ�������֤���
  <dt class="String">to_s 
  <dd>HTML���֤���
  <dt class="Iterator">each {|<var>obj</var>,<var class="Array">tag</var>| ...}
  <dd>�ɥ�����Ȥγƥ��֥�������(<var>obj</var>)���Ф��ƥ֥�å���ɾ�����ޤ���
      <var class="Array">tag</var>�ϳ��ϥ����Υꥹ�ȡ� [ StartTag , <var class="Integer">����ǥ���</var>] ��
  <dt class="Integer">index(<var class="Class">class</var>, <var class="Integer">start</var>, <var class="Integer">end</var>, <var>value</var>, <var class="Integer">count</var>) {|obj| ...}
  <dd><var class="Integer">start</var>����<var class="Integer">end</var>�ޤǤ����Ǥ�<var class="Class">class</var>��������<var class="Integer">count</var>���ܤ����Ǥΰ��֤��֤��ޤ���
      ���������Ǥ��ҤȤĤ�ʤ��ä����ˤ�nil���֤��ޤ���<br>
      <var>value</var>��nil�ʳ����ͤ���ꤷ�����ˤ����Ǥ�<var>value</var>���������������å���Ԥ��ޤ���<var class="Class">class</var>��EmptyElementTag,StartTag,EndTag�λ��ϥ���̾������ʳ��ϥƥ����Ȥˤ�ä���Ӥ��ޤ���<br>
      �֥�å�����ꤷ�ƸƤӽФ��줿���ˤϥ֥�å������Ǥ���������ɾ�����롣
  <dt class="Integer">end_index(<var class="Integer">start</var>)
  <dd><var class="Integer">start</var>���б�����EndTag�Υ���ǥ������֤��ޤ���
      �б��������Ǥ��ʤ��ä����ˤ�nil���֤��ޤ���<br>
</dl>
=end
	EMPTY = %w(area base basefont bgsound br col frame hr img input isindex 
	           keygen link meta nextid param spacer wbr)

  def HTMLSplit.make_char(encoding, code, unmatch)
    if code == 0x9 || code == 0xa || code == 0xd || code >= 0x20 && code <= 0xff
      code.chr
    else
      if (code <= 0xd7ff ||
          code >= 0xe000 && code <= 0x10ffff && code != 0xfffe && code != 0xffff) && 
         encoding == "UTF8"
        [code].pack("U")
      else
        unmatch
      end
    end
  end

  def HTMLSplit.unescapeHTML(string, encoding)
    string.gsub(/&(.*?);/n) {
      match = $1.dup
      case match
      when /\Aamp\z/ni           then '&'
      when /\Aquot\z/ni          then '"'
      when /\Aapos\z/ni          then "'"
      when /\Agt\z/ni            then '>'
      when /\Alt\z/ni            then '<'
      when /\A#0*(\d+)\z/n
        HTMLSplit.make_char(encoding, Integer($1), "&##{$1};")
      when /\A#x([0-9a-f]+)\z/ni
        HTMLSplit.make_char(encoding, $1.hex, "&#x#{$1};")
      else
        "&#{match};"
      end
    }
  end

  def make_tag(name, attr)
    name.downcase!
    if @empty_tags.include?(name)
      @document << EmptyElementTag.new(name, attr)
    else
      if name[0, 1] == '/'
        @document << EndTag.new(name[1..-1])
      else
        @document << StartTag.new(name, attr)
      end
    end
  end
  private :make_tag

  def initialize(html = nil, encoding = $KCODE)
    @empty_tags = EMPTY
    set_html(html, encoding) if html
  end
  attr_accessor :empty_tags

  def set_html(html, encoding = $KCODE)
		@document = []	#�ѡ�������HTML�Υꥹ��
		name = ''
		text = ''
		attr = OrderedHash.new
		attrname = ''
		state = :TEXT
		#
		html.each_byte {|c|
			char = c.chr
			case state
			when :TEXT
				if c==60
					if text.length>0
						@document << CharacterData.new(text)
					end
					name = ''
					attr = OrderedHash.new
					state = :TAGNAME
				else
					text << char
				end
			when :TAGNAME
        if name.length == 0
				case char
				when '!'
					text = ''
					state = :DECLARE
				when '%'
					text = ''
					state = :ERUBY
				when '?'
					text = ''
					state = :PHP
          when /[a-zA-Z_:\/]/
            name << char
          else
            text = '<' + char
            state = :TEXT
          end
        else
          case char
          when '>'
            make_tag(name, nil)
            text = ''
            state = :TEXT
				when /\s/
					text=''
					state = :SPACE
          when /[a-zA-Z0-9\._:-]/
					name << char
          else
            text = ''
            state = :SPACE
            redo
          end
				end
			when :SPACE	#°���֤ζ���
				case char
				when '>'
          make_tag(name, attr)
					text = ''
					state = :TEXT
        when '<'  # �Ĥ��ʤ����ϥ���
          make_tag(name, attr)
          name = ''
          attr = OrderedHash.new
          state = :TAGNAME
				when /\s/
				else
					attrname=char
					state = :ATTRNAME
				end
			when :ATTRNAME	#°��̾
				case char
				when /\s/
					state = :BEFOREEQUAL
				when '='
					state = :AFTEREQUAL
				when '>'
					attr[attrname.downcase]=true
          make_tag(name, attr)
					text = ''
					state = :TEXT
				else
					attrname << char
				end
			when :BEFOREEQUAL	#=
				case char
				when '='
					state = :AFTEREQUAL
				when '>'
					attr[attrname.downcase]=true
          make_tag(name, attr)
					text = ''
					state = :TEXT
				when /\s/
				else
					attr[attrname.downcase]=true
					attrname = char
					state = :ATTRNAME
				end
			when :AFTEREQUAL	#=
				case char
				when "'"
					text=''
					state = :SQVALUE
				when '"'
					text=''
					state = :DQVALUE
				when '>'
					attr[attrname.downcase]=true
          make_tag(name, attr)
					text = ''
					state = :TEXT
				when /\s/
				else
					text=char
					state = :VALUE
				end
			when :VALUE		#��
				case char
				when /\s/
          attr[attrname.downcase] = HTMLSplit.unescapeHTML(text, encoding)
					state = :SPACE
				when '>'
          attr[attrname.downcase] = HTMLSplit.unescapeHTML(text, encoding)
          make_tag(name, attr)
					text = ''
					state = :TEXT
				else
					text << char
				end
			when :SQVALUE	#'��'
				if c==39
          attr[attrname.downcase] = HTMLSplit.unescapeHTML(text, encoding)
					state = :SPACE
				else
					text << char
				end
			when :DQVALUE	#"��"
				if c==34
          attr[attrname.downcase] = HTMLSplit.unescapeHTML(text, encoding)
					state = :SPACE
				else
					text << char
				end
			when :COMMENT
				case char
				when '>'
					if text[-2,2]=='--'	#�����Ƚ�λ	
						text = text[0..-3]
						if text=~/^#[a-z]+/	#SSI
							@document << SSI.new(text)
						else
							@document << Comment.new(text)
						end
						text = ''
						state = :TEXT
					else
						text << char
					end
				else
					text << char
				end
			when :ERUBY
				case char
				when '>'
					if text[-1,1]=='%'	#eRuby��λ	
						text = text[0..-2]
						@document << ERuby.new(text)
						text = ''
						state = :TEXT
					else
						text << char
					end
				else
					text << char
				end
			when :PHP
				case char
				when '>'
					if text[-1,1]=='?'	#eRuby��λ	
						text = text[0..-2]
						@document << PHP.new(text)
						text = ''
						state = :TEXT
					else
						text << char
					end
				else
					text << char
				end
			when :DECLARE
				case char
				when '>'
					@document << Declaration.new(text)
					text = ''
					state = :TEXT
				else
					text << char
					if text=='--'
						text = ''
						state = :COMMENT
					end
				end
			end
		}
		#EOF�ν���
		case state
		when :TEXT
			@document << CharacterData.new(text) if text.length>0
		when :TAGNAME
			@document << CharacterData.new('<'+text)
		when :SPACE	#°���֤ζ���
      make_tag(name, attr)
		when :ATTRNAME	#°��̾
			attr[attrname.downcase]=true
      make_tag(name, attr)
		when :BEFOREEQUAL	#=
			attr[attrname.downcase]=true
      make_tag(name, attr)
		when :AFTEREQUAL	#=
			attr[attrname.downcase]=true
      make_tag(name, attr)
		when :VALUE		#��
      attr[attrname.downcase] = HTMLSplit.unescapeHTML(text, encoding)
      make_tag(name, attr)
		when :SQVALUE	#'��'
      attr[attrname.downcase] = HTMLSplit.unescapeHTML(text, encoding)
		when :DQVALUE	#"��"
      attr[attrname.downcase] = HTMLSplit.unescapeHTML(text, encoding)
		when :COMMENT
			if text=~/^#[a-zA-Z]+/	#SSI
				@document << SSI.new(text)
			else
				@document << Comment.new(text)
			end
		when :ERUBY
			@document << ERuby.new(text)
		when :PHP
			@document << PHP.new(text)
		when :DECLARE
			@document << Declaration.new(text)
		end
	end
	#
	attr_accessor :document
	#
	def to_s
		s = ''
		@document.each {|e|
			s<<(e.to_s)
		}
		s
	end
	#
	def each
		tag = []
		i = 0
		@document.each {|e|
			case e
			when StartTag
				tag.push [e,i]
			when EndTag
				idx = nil
				(tag.size-1).downto(0) {|j|
					if tag[j][0].name==e.name
						idx = j
						break
					end
				}
				#
				if idx
					if idx==0
						tag = []
					else
						tag = tag[0..idx-1]
					end
				end
			else
			end
			yield e,tag
			i += 1
		}
	end
	#
	def index(_class,_start=0,_end=-1,value=nil,count=1)
		idx=_start
		found=false
		@document[_start.._end].each {|obj|
			if obj.type==_class
				if value
					case obj
					when StartTag,EmptyElementTag,EndTag
						if value===obj.name
							if (not iterator?) or yield(obj)
								if (count-=1)<=0
									found = true
									break
								end
							end
						end
					else
						if value===obj.text
							if (not iterator?) or yield(obj)
								if (count-=1)<=0
									found = true
									break
								end
							end
						end
					end
				else
					if (not iterator?) or yield(obj)
						if (count-=1)<=0
							found = true
							break
						end
					end
				end
			end
			idx+=1
		}
		if found
			idx
		else
			nil
		end
	end
	#
	def end_index(start_index)
		tag = []
		end_index = nil
		(start_index...@document.size).each {|idx|
			e= @document[idx]
			case e
			when StartTag
				tag.push [e,idx]
			when EndTag
				i = nil
				(tag.size-1).downto(0) {|j|
					if tag[j][0].name==e.name
						i = j
						break
					end
				}
				#
				if i
					if i==0
						tag = []
					else
						tag = tag[0..i-1]
					end
				end
				if tag.size==0
					end_index = idx
					break
				end
			else
			end
		}
		end_index
	end
end
=begin End of Document
</body>
</html>
=end

if __FILE__ == $0
  html = <<END
<br clear="all" />
END
=begin 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>htmlsplit.rb</title>
<link href="rubydoc.css" rel="stylesheet">
</head>
<body>
| <a href="./">���</a> |
<h1>HTML Split Library</h1>
<p> HTML���ɤ߽񤭤��롣 �ɤ߹����ʸ��ϥ�����ʸ���������ˤʤ롣 to_s�᥽�å�
��HTML���᤹���Ȥ�����롣</p>
<h2>���饹����</h2>
  hogehoge
  <!-- comment -->
  <hr />
</body>
</html>
=end

  scanner = HTMLSplit.new(html)
  scanner.document.each do |tag|
    p tag
  end
end
