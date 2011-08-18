namespace :ui do

  desc "Print SCSS includes for all available file types available in assets/images/file-type/*png"
  task :file_type_css do
    files = Dir.glob(File.join(Rails.root, 'app', 'assets', 'images', 'file-type', '*.png'))
    files.each do |file|
      basename = File.basename(file, '.png')
      puts "@include file-type-icon('#{basename}');" unless basename == 'unknown'
    end
  end

end
