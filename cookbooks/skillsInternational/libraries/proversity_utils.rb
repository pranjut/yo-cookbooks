module Proversity

  require 'fileutils'


    def self.extract
      unzip_file "#{install_dir}.zip", "#{install_dir}"
      FileUtils.chmod "u+x", "#{install_dir}/start"
    end

    def self.unzip_file (file, destination)
      Zip::File.open(file) { |zip_file|
        zip_file.each { |f|
          unless f.directory?
            f_path=::File.join(destination, f.name)
            FileUtils.mkdir_p(::File.dirname(f_path))
            zip_file.extract(f, f_path) { true }
          end
        }
      }
    end
end