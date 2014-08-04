# -*- coding: utf-8 -*-

require 'logger'

class Shots
  @@logfile = File.join('log', 'spec.log')

  @@logger = Logger.new @@logfile
  @@logger.level = Logger::DEBUG
  @@logger_stdout = Logger.new($stdout)
  @@logger_stdout.level = Logger::DEBUG

  def initialize
    @seq_no = 0
  end

  def log_write(str)
    mes = "# #{str}"
    @@logger.info mes
    @@logger_stdout.info mes
  end

  def action_and_screenshot(wd, name, sub_no, message = nil)
    name = "#{format('%04d', @seq_no)}-#{name}_#{sub_no}"
    png_name = File.join(SCREENSHOTS_DIR, "#{name}.png")

    log_write message if message
    log_write "capture #{png_name}"

    wd.save_screenshot png_name

    http_name = File.join(HTMLSHOTS_DIR, "#{name}.html")
    File.write http_name, wd.page_source

    @seq_no += 1
  end
end
