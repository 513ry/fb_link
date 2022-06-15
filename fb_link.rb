#!/usr/bin/env ruby

PREFIX_L = 30.freeze

if ARGV.empty?
  warn 'No argument found. Please enter a facebook link'
  exit 1
end

full_link = ARGV[0]
if full_link[0..PREFIX_L] != 'https://l.facebook.com/l.php?u='
  warn 'Entered argument is not a valid facebook link'
  exit 2
end

full_link = full_link[PREFIX_L + 1..-1]
replace = {'3A' => ':', '2F' => '/', '3F' => '?', '3D' => '=', '26' => false}
skip = 0

catch :loop_label do
  full_link.each_char.with_index do |char, index|
    if char == '%'
      replace.keys.each do |key|
        if full_link[index - skip + 1..index + 2 - skip] == key
          if replace[key] == false or (replace[key] == '?' and
              full_link[index - skip + 3..index - skip + 8] == 'fbclid')
            full_link = full_link[0..index - skip - 1]
            throw :loop_label
          end
          full_link[index - skip..index + 2 - skip] = replace[key]
          skip += 2
          break
        end
      end
    end
  end
end

puts full_link
