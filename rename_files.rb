# coding: utf-8

require 'csv'

@folder = ARGV[0]
raise "Folder not found" unless File.directory?(@folder)
raise "list.csv not found" unless File.exists?("#{@folder}/list.csv")

@years = []
CSV.foreach("#{@folder}/list.csv") do |row|
  number = row[0].to_i
  year = row[1][-4..-1]
  next unless number > 0
  @years[number] = year
end

@files = []
Dir.foreach(@folder) do |file|
  next if file == '.' or file == '..' or file == '.DS_Store' or file == 'list.csv'
  @files << file
end

@files.each do |file|
  parsed_file = file.match(/\A(\d+)-(.+)-(.+)\.(\S{3})\z/)
  unless parsed_file
    puts "*" * (file.length + 38)
    puts "*** File '#{file}' in wrong naming format ***"
    puts "*" * (file.length + 38)
    next
  end
  @number = parsed_file[1].to_i
  @title = parsed_file[2]
  @singer = parsed_file[3]
  @singer = nil if @singer == "Instrumental" || @singer == "Solo de piano"
  @extension = parsed_file[4]
  @year = @years[@number]
  @file_name = "#{@year} #{@title}#{" (#{@singer})" if @singer}.#{@extension}"
  File.rename("#{@folder}/#{file}", "#{@folder}/#{@file_name}")
end
