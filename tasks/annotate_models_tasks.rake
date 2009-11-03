desc "Add filename information (as comments) to view files"

task :annotate_views do
   require File.join(File.dirname(__FILE__), "../lib/annotate_views.rb")
   AnnotateViews.do_annotations
end