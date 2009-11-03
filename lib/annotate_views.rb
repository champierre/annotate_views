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
      header = "<!-- #{PREFIX} BEGINNING OF #{info} -->\n"
      footer = "<!-- #{PREFIX} END OF #{info} -->\n"

      # Remove old filename info
      content.gsub!(/^<!-- #{PREFIX}.*? -->\n/, '')

      # Write it back
      File.open(file_name, "w") { |f| f.puts header + content + footer}
    end
  end

  def self.annotate(view_file)
    view_file_name = File.join(VIEW_DIR, view_file)

    # Skip mailer or notifier view files.
    unless view_file =~ /mailer\// || view_file =~ /notifier\//
      annotate_one_file(view_file_name, view_file)
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
    self.get_view_files.each do |v|
      begin
        puts "Annotating #{v}"
        self.annotate(v)
      rescue Exception => e
        puts "Unable to annotate #{v}: #{e.message}"
      end
    end
  end
end
