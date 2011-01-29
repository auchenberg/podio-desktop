module OsHelper
	require 'rbconfig'

	@os = RbConfig::CONFIG['target_os']

	def OsHelper.is_linux?
		@os.downcase.include?('linux')
	end

	def OsHelper.is_windows?
		@os.downcase.include?('mswin')
	end

	def OsHelper.is_osx?
		@os.downcase.include?('darwin')
	end
end