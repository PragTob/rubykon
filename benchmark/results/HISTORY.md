## 0.1 (first really naive implementation)

```
Running rbx with
Using /home/tobi/.rvm/gems/rbx-2.5.2
Calculating -------------------------------------
9x9 full playout (+ score)
                         4.000  i/100ms
13x13 full playout (+ score)
                         3.000  i/100ms
19x19 full playout (+ score)
                         1.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        112.237  (±11.6%) i/s -      2.212k
13x13 full playout (+ score)
                         52.475  (± 9.5%) i/s -      1.041k
19x19 full playout (+ score)
                         22.600  (±13.3%) i/s -    442.000 
Running 1.9.3 with
Using /home/tobi/.rvm/gems/ruby-1.9.3-p551
Calculating -------------------------------------
9x9 full playout (+ score)
                        10.000  i/100ms
13x13 full playout (+ score)
                         4.000  i/100ms
19x19 full playout (+ score)
                         2.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        111.529  (± 8.1%) i/s -      2.220k
13x13 full playout (+ score)
                         48.059  (±10.4%) i/s -    952.000 
19x19 full playout (+ score)
                         19.788  (±15.2%) i/s -    390.000 
Running jruby-dev-graal with -X+T -J-Xmx1500m
Using /home/tobi/.rvm/gems/jruby-dev-graal
Calculating -------------------------------------
9x9 full playout (+ score)
                         1.000  i/100ms
13x13 full playout (+ score)
                         1.000  i/100ms
19x19 full playout (+ score)
                         1.000  i/100ms
Calculating -------------------------------------
9x9 full playout (+ score)
                          5.787  (± 34.6%) i/s -    102.000 
13x13 full playout (+ score)
                          3.598  (± 27.8%) i/s -     67.000 
19x19 full playout (+ score)
                          1.849  (± 0.0%) i/s -     36.000 
Running jruby with
Using /home/tobi/.rvm/gems/jruby-9.0.1.0
Calculating -------------------------------------
9x9 full playout (+ score)
                         9.000  i/100ms
13x13 full playout (+ score)
                        10.000  i/100ms
19x19 full playout (+ score)
                         4.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        237.441  (±11.0%) i/s -      4.680k
13x13 full playout (+ score)
                        105.639  (± 9.5%) i/s -      2.090k
19x19 full playout (+ score)
                         44.741  (±11.2%) i/s -    884.000 
Running jruby-1 with
Using /home/tobi/.rvm/gems/jruby-1.7.22
Calculating -------------------------------------
9x9 full playout (+ score)
                        11.000  i/100ms
13x13 full playout (+ score)
                         9.000  i/100ms
19x19 full playout (+ score)
                         4.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        224.768  (±15.6%) i/s -      4.356k
13x13 full playout (+ score)
                        105.326  (± 7.6%) i/s -      2.097k
19x19 full playout (+ score)
                         43.576  (±11.5%) i/s -    864.000 
Running 2.2 with
Using /home/tobi/.rvm/gems/ruby-2.2.3
Calculating -------------------------------------
9x9 full playout (+ score)
                        14.000  i/100ms
13x13 full playout (+ score)
                         6.000  i/100ms
19x19 full playout (+ score)
                         2.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        139.838  (± 6.4%) i/s -      2.786k
13x13 full playout (+ score)
                         60.935  (± 8.2%) i/s -      1.212k
19x19 full playout (+ score)
                         25.423  (±11.8%) i/s -    502.000
```