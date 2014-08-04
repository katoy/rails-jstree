# -*- coding: utf-8 -*-

module TreeHelper

  require 'csv'

  # =========================================================
  # CSV (key,val) を そのまま ハッシュにする。
  def read_csv_as_hash(file)
    hash = {}
    CSV.foreach(file, skip_blanks: true) do |row|
      row[1] = '' if row.size == 1
      hash[row[0]] = row[1]
    end
    hash.freeze
  end

  # jstree 用に変換する。
  def csv_hash2json(hash, path = '')
    ans = []
    cp = ans
    hash.each do |k, v|
      c_path = "#{path}/#{k}"
      if v.kind_of?(String)
        ans << {id: c_path, text: "<strong>#{k}</strong>:\t#{v}", type: 'file'} if k != ''
      else
        c_text = "<strong>#{k}</strong>"
        c_type = 'folder'
        if v['']
          c_text = "#{c_text}:\t#{v['']}"
          c_type = 'file'
        end
        ans << {id: c_path, text: c_text, type: c_type, children: csv_hash2json(v, c_path)}
      end
    end
    ans
  end

  # ネストしたハッシュに変換する。
  def csv_to_hash(src)
    hash = {}
    src.each do |key, val|
      axis = key.to_s.scan(/((\w+?)(\d+))/)
      name = $'
      name = key if axis.size == 0
      hash.merge! sub_hash(axis, name, val, hash)
    end
    hash
  end

  def sub_hash(axis, name, val, hash = {})
    if axis.size == 0
      name = :val if name.nil? || name == ''
      return name => val
    end

    (ax, idx) = [axis[0][1], axis[0][2].to_i]
    hash[ax] = {} unless hash[ax]
    hash[ax][idx] = {} unless hash[ax][idx]
    axis.shift
    if axis.size == 0
      k = name || ''
      hash[ax][idx].merge!(k => val)
    else
      hash[ax][idx].merge! sub_hash(axis, name, val, hash[ax][idx])
    end
    hash
  end

  # キーを指定して ネストしたハッシュから値を得る。
  def get_values_from_nested_hash(hash, key)
    axis = key.to_s.scan(/((\w+?)(\d+?))/)
    name = $'
    name = '' if name.nil?
    v = hash
    axis.each do |x|
      ax = x[1]
      idx = x[2].to_i
      return nil unless v[ax] && v[ax][idx]
      v = v[ax][idx]
    end
    v[name]
  end

  # =========================================================
  # ディレクトリーのファイル情報を jstree 用の 形式で得る。
  def generate_filetree(root_path)
    # ディレクトリーのファイル情報を ネストした hash で得る
    dir_hash = dirHash(root_path)
    # jstree 用の形式に変換する。
    ans = dirHash2Json(dir_hash)
    ans
  end

  # ディレクトリーのファイル情報を nest した hash 形式で得る。
  def dirHash(root_path)
    children = {}
    root_path_index = root_path.split('/').size
    Dir.glob("#{root_path}/**/*").each do |f|
      next if /[#~]/ =~ f
      names = f.split('/')[root_path_index .. -1]
      isFile = File::ftype(f) == 'file'
      cp = children
      parent = nil
      names.each do |name|
        cp[name] = {} if cp[name] == nil
        parent = cp
        cp = cp[name]
      end
      parent[names[-1]] = nil if isFile && parent
    end
    children
  end

  # ネストした hash を jstree 用の json に変換する。
  def dirHash2Json(children, path = '')
    ans = []

    children.each do |k, v|
      c_path = "#{path}/#{k}"
      if v
        # directory
        ans << {id: c_path, text: k, type: 'folder', children: dirHash2Json(v, c_path) }
      else
        # file
        ext = File.extname(k)
        f_icon = 'file'
        f_icon += " file-#{ext[1..-1]}" if ext.length > 1
        ans << {id: c_path, text: k, type: 'file', icon: f_icon}
      end
    end
    ans
  end

end
