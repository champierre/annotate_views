desc "Add filename information (as comments) to view files"
task :annotate_views do
  require File.join(File.dirname(__FILE__), "../annotate_views.rb")
  AnnotateViews.do_annotations
end

desc "Remove filename information from view files"
task :deannotate_views => :environment do
  require File.join(File.dirname(__FILE__), "../annotate_views.rb")
  AnnotateViews.remove_annotations
end