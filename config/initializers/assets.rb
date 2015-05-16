Rails.application.config.assets.precompile += %w( about_us.css )
Rails.application.config.assets.precompile += %w( abouts.js )

Rails.application.config.assets.precompile += %w( home.css )
Rails.application.config.assets.precompile += %w( home.js )
Rails.application.config.assets.precompile += %w( wizard.js )
Rails.application.config.assets.precompile += %w( wizard.css )
Rails.application.config.assets.precompile += %w( landing.css )
Rails.application.config.assets.precompile += %w( jquery.js )
Rails.application.config.assets.precompile += %w( loader.js )
Rails.application.config.assets.precompile += %w( staff_jeditable.js )
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/