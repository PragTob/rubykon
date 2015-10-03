## 0.2 (Simplified board representation)

Notable is that these changes weren't done for performance reasons apparent in these benchmarks, as benchmark-ips does run GC so the lack of GC runs should not affect it. Maybe the benefit of creating less objects.

Some ruby versions showed notable differences (rbx, jruby 9k) while others (CRuby, jruby 1.7) showed nice gains. On 19x19 CRuby 2.2.3 went 25 --> 34, jruby 1.7 went 43 --> 54.

```
Running rbx with
Using /home/tobi/.rvm/gems/rbx-2.5.2
Calculating -------------------------------------
9x9 full playout (+ score)
                         7.000  i/100ms
13x13 full playout (+ score)
                         4.000  i/100ms
19x19 full playout (+ score)
                         1.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        117.110  (± 7.7%) i/s -      2.331k
13x13 full playout (+ score)
                         53.714  (± 7.4%) i/s -      1.068k
19x19 full playout (+ score)
                         23.817  (±12.6%) i/s -    467.000 
Running 1.9.3 with
Using /home/tobi/.rvm/gems/ruby-1.9.3-p551
Calculating -------------------------------------
9x9 full playout (+ score)
                        15.000  i/100ms
13x13 full playout (+ score)
                         6.000  i/100ms
19x19 full playout (+ score)
                         2.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        149.826  (± 6.0%) i/s -      3.000k
13x13 full playout (+ score)
                         66.382  (± 9.0%) i/s -      1.320k
19x19 full playout (+ score)
                         28.114  (±10.7%) i/s -    554.000 
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
                          9.828  (± 40.7%) i/s -    158.000 
13x13 full playout (+ score)
                          4.046  (± 24.7%) i/s -     70.000 
19x19 full playout (+ score)
                          5.289  (± 37.8%) i/s -     87.000 
Running jruby with
Using /home/tobi/.rvm/gems/jruby-9.0.1.0
Calculating -------------------------------------
9x9 full playout (+ score)
                        11.000  i/100ms
13x13 full playout (+ score)
                        10.000  i/100ms
19x19 full playout (+ score)
                         4.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        243.322  (± 7.8%) i/s -      4.829k
13x13 full playout (+ score)
                        105.500  (± 6.6%) i/s -      2.100k
19x19 full playout (+ score)
                         45.046  (± 8.9%) i/s -    896.000 
Running jruby-1 with
Using /home/tobi/.rvm/gems/jruby-1.7.22
Calculating -------------------------------------
9x9 full playout (+ score)
                        14.000  i/100ms
13x13 full playout (+ score)
                        12.000  i/100ms
19x19 full playout (+ score)
                         5.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        279.079  (±11.8%) i/s -      5.488k
13x13 full playout (+ score)
                        128.978  (± 7.0%) i/s -      2.568k
19x19 full playout (+ score)
                         54.526  (± 9.2%) i/s -      1.085k
Running 2.2 with
Using /home/tobi/.rvm/gems/ruby-2.2.3
Calculating -------------------------------------
9x9 full playout (+ score)
                        18.000  i/100ms
13x13 full playout (+ score)
                         8.000  i/100ms
19x19 full playout (+ score)
                         3.000  i/100ms
-------------------------------------------------
9x9 full playout (+ score)
                        183.983  (± 4.9%) i/s -      3.672k
13x13 full playout (+ score)
                         80.525  (± 6.2%) i/s -      1.608k
19x19 full playout (+ score)
                         34.117  (± 8.8%) i/s -    678.000 
```

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