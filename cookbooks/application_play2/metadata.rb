name             'application_play2'
maintainer       'njin'
maintainer_email 'bathily@njin.fr'
license          'All rights reserved'
description      'Installs/Configures application_play2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

%w{ application play2 }.each do |cb|
  depends cb
end
