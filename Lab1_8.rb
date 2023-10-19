include Math

x = gets.chomp

f = gets.chomp

b = gets.chomp

x = x.to_f
f = f.to_f
b = b.to_f

PI = 3.14

K = Math.acos(Math.sin(x/2) /(b-1) ** (1.0/3)) + Math.log(Math.exp(f) + 4.1* 10 ** 2.1) / Math.tan(PI/4 + x/2)

puts K