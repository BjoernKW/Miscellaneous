#!/usr/bin/env ruby

overall_counter = 0

Dir.glob("#{ARGV[0]}/**/*.spec.ts") do |spec_file|
	print File.basename(spec_file).sub('.spec', '')

	File.open(spec_file, 'r') do |file_handle|
		declarations_active = false
		imports_active = false
		providers_active = false

		declarations_counter = 0
		imports_counter = 0
		providers_counter = 0

		file_handle.each_line do |line|
			if line =~ /^      \]/
				if declarations_active
					declarations_active = false
				end
				if imports_active
					imports_active = false
				end
				if providers_active
					providers_active = false
				end
			end

			if declarations_active
				declarations_counter += 1
				overall_counter += 1
			end
			if imports_active
				imports_counter += 1
			end
			if providers_active
				providers_counter += 1
			end

			if line =~ /declarations: .+/
				declarations_active = true
			end
			if line =~ /imports: .+/
				imports_active = true
			end
			if line =~ /providers: .+/
				providers_active = true
			end
		end

		puts " - declarations: #{declarations_counter}, imports: #{imports_counter}, providers: #{providers_counter}, overall: #{declarations_counter + imports_counter + providers_counter}"
	end
end

puts '------------------'
puts overall_counter
