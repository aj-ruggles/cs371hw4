if ARGV.empty?
  puts "Usage: ruby convert.rb INPUT"
  puts "INPUT: Hex-Color or Dec-Color"
  puts "if Hex-Color then example `#FFFFFF`"
  puts "if Dec-Color then example `256, 34, 98`"
elsif ARGV.length == 1
  n1, n2, n3 = ARGV[0][0..1], ARGV[0][2..3], ARGV[0][4..5]
  puts "#{(n1.to_i(16)).to_f/255}, #{(n2.to_i(16)).to_f/255}, #{(n3.to_i(16)).to_f/255}"
elsif ARGV.length == 3
  n1, n2, n3 = ARGV[0].chomp(","), ARGV[1].chomp(","), ARGV[2].chomp(",")
  puts "#{n1.to_i/255}"
end
