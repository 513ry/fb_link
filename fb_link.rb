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
replace = {'3A' => ':', '2F' => '/', '3F' => '?', '3D' => '='}

skip = 0

full_link.each_char.with_index do |char, index|
  if char == '%'
    if full_link[index - skip + 1..index + 2 - skip] == '26'
      full_link = full_link[0..index - skip - 1]
      break
    end
    replace.keys.each do |key|
      warn "#{index}: #{full_link[index - skip + 1..index + 2 - skip]} ~ #{key}"
      if full_link[index - skip + 1..index + 2 - skip] == key
        warn skip
        full_link[index - skip..index + 2 - skip] = replace[key]
        skip += 2
        break
      end
    end
  end
end

puts full_link
