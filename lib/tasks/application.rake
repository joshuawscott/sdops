namespace :notes do
  desc "Enumerate all debugger annotations"
  task :debugger do
    SourceAnnotationExtractor.enumerate "debugger"
  end
end

