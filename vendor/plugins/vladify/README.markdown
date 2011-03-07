# Intent

This is a plugin that automattes the way we deploy 95% of our projects.
Its still little to astrails-specific, but only in the defaults foudn
in the generated config/deploy.rb

# Prerequisites

* vlad 1.4.0

# Usage

Run:
    ./script/generate vladify

Edit:
	vim config/deploy.rb

Add to 'Rakefile':

    require 'vlad'
	require 'vlad/core'
	Vlad.load :scm => :git, :app => nil, :web => nil

# Details

Apache/Nginx + passenger deployment.
uncomment includes in config/deploy.rb to enable optional features.

The vlad tasks will attempt to deploy into ROOT = /var/www/APPLICATION_NAME
the following structure is used:

- ROOT
  - releases
    - NUMNBERED_RELEASE_DIRECTORY
      - config
        - shared => ../../shared
  - current -> latest relase dir
  - shared
    - config
      - files found here are COPIED into ROOT/config during deployment
        this is the place you should place your server specific database.yml etc.
        subdirectories are supported. i.e. foo/bar.conf will be copied to config/foo/bar.conf
    
