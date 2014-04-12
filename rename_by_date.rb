# coding: utf-8

@folder = ARGV[0]
raise "Folder not found" unless File.directory?(@folder)

@files = []
Dir.foreach(@folder) do |file|
  next if file == '.' or file == '..' or file == '.DS_Store' or file == 'list.csv'
  @files << file
end

@files.each do |file|
  parsed_file = file.match(/\A\d+(?:-|.\s)([^-\(]+)(?:-([^\(]+))?(?:\(.+\))?\s?\(\d{2}-\d{2}-(\d{4})\)\.(\S{3})\z/)
  unless parsed_file
    puts "*" * (file.length + 38)
    puts "*** File '#{file}' in wrong naming format ***"
    puts "*" * (file.length + 38)
    File.rename("#{@folder}/#{file}", "#{@folder}/[Review] #{file}") unless file.match(/\[Review\]/)
    next
  end
  @title = parsed_file[1].strip
  @singer = parsed_file[2].strip if parsed_file[2]
  @singer = nil if @singer == "Instrumental" || @singer == "Solo de piano"
  @year = parsed_file[3].strip
  @extension = parsed_file[4]
  @file_name = "#{@year} #{@title}#{" (#{@singer})" if @singer}.#{@extension}"
  File.rename("#{@folder}/#{file}", "#{@folder}/#{@file_name}")
end
