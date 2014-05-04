# -*- coding: utf-8 -*-

class TreeController < ApplicationController

  include TreeHelper

  TREE_ROOT_DIR = 'app'
  CSV_FILE = 'test/test.csv'

  def index
    respond_to do |format|
      format.html
    end
  end

  def treeData
    data = generate_filetree(TREE_ROOT_DIR)
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def treeDataCsv
    csv_hash = read_csv_as_hash(CSV_FILE)
    h = csv_to_hash(csv_hash)
    data = csv_hash2json(h)

    file_path = "#{TREE_ROOT_DIR}#{params[:path]}"

    respond_to do |format|
      format.json { render json: data }
    end
  end

  # 指定ファイルの内容を返す。
  # TODO: app 以下以外のファイルの場合はエラーにすること。
  def fileData
    file_path = "#{TREE_ROOT_DIR}#{params[:path]}"
    cont = ''
    begin
      raise "error" if file_path.index('..')
      if /\.png\z/i =~ file_path || /\.gif\z/i =~ file_path
        cont = file_path
      else
        cont = File.open(file_path).read
      end
      render text: cont
    rescue => e
      cont = "#{e}"
    end
  end

  def imageData
    file_path = 'public/fish.png' # "#{TREE_ROOT_DIR}#{params[:path]}"
    send_data(File.open(file_path).read,
              :filename => '1.png', :type => 'image/png', :disposition => 'inline')
  end

end
