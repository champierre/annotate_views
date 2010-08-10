#require "config/environment"

VIEW_DIR = File.join(RAILS_ROOT, "app/views")

module AnnotateViews

  PREFIX = "AnnotateViews:"

  # Add info blocks to a file. If the file already contains
  # info blocks (a comment starting
  # with "AnnotateViews: ..."), remove it first.

  def self.annotate_one_file(file_name, relative_path)
    if File.exist?(file_name)
      content = File.read(file_name)
      info = "app/views/" + relative_path
      header = "<%= \"<!-- #{PREFIX} BEGINNING OF #{info} -->\" if RAILS_ENV == 'development' %>\n"
      footer = "\n<%= \"<!-- #{PREFIX} END OF #{info} -->\" if RAILS_ENV == 'development' %>\n"

      # Remove old filename info
      content.gsub!(/^<%= "<!-- #{PREFIX} BEGINNING OF .*? -->" if RAILS_ENV == 'development' %>\n/, '')
      content.gsub!(/\n^<%= "<!-- #{PREFIX} END OF .*? -->" if RAILS_ENV == 'development' %>\n/, '')

      # Write it back
      File.open(file_name, "w") { |f| f.puts header + content + footer}
    end
  end

  def self.remove_annotation_of_one_file(file_name)
    if File.exist?(file_name)
      content = File.read(file_name)

      # Remove filename info
      content.gsub!(/^<%= "<!-- #{PREFIX} BEGINNING OF .*? -->" if RAILS_ENV == 'development' %>\n/, '')
      content.gsub!(/\n^<%= "<!-- #{PREFIX} END OF .*? -->" if RAILS_ENV == 'development' %>\n/, '')

      # Write it back
      File.open(file_name, "w") { |f| f.puts content}
    end
  end

  def self.annotate(view_file)
    view_file_name = File.join(VIEW_DIR, view_file)

    # Skip mailer or notifier view files and layouts.
    unless view_file =~ /mailer\// || view_file =~ /notifier\// || view_file =~ /layouts\//
      annotate_one_file(view_file_name, view_file)
    end
  end

  def self.remove_annotation_of(view_file)
    view_file_name = File.join(VIEW_DIR, view_file)

    # Skip mailer or notifier view files and layouts.
    unless view_file =~ /mailer\// || view_file =~ /notifier\// || view_file =~ /layouts\//
      remove_annotation_of_one_file(view_file_name)
    end
  end

  def self.get_view_files
    views = []
    Dir.chdir(VIEW_DIR) do
      views = Dir["**/*.rhtml", "**/*.html.erb"]
    end
    views
  end

  def self.do_annotations
    self.get_view_files.each do |file|
      begin
        puts "Annotating #{file}"
        self.annotate(file)
      rescue Exception => e
        puts "Unable to annotate #{file}: #{e.message}"
      end
    end
  end

  def self.remove_annotations(options={})
    self.get_view_files.each do |file|
      begin
        puts "Removing annotation of #{file}"
        self.remove_annotation_of(file)
      rescue Exception => e
        puts "Unable to remove annotation of #{file}: #{e.message}"
      end
    end
  end
end
