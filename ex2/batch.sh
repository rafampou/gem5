# gem5 Directory
gem5_dir=~/gem5  # Directory of gem5 installation
benchmarks_dir=$gem5_dir/spec_cpu2006  # Directory of Benchmarks
cpu_types=(MinorCPU)
benchmarks_output=$gem5_dir/Benchmarks_results

l1_data_size=(32kB 16kB 128kB 64kB 128kB) # l1_data_size + l_instraction_size < 256kB
l1_instraction_size=(64kB 16kB 32kB 128kB)
l2_size=(512kB 256kB 1MB 2MB 4MB) # less than 4MB
l1_instraction_assoc=(1 2 4)
l1_data_assoc=(1 2 4)
l2_data_assoc=(2 1 4)
caseline_size=(64 32 128)
cpu_clock=(1GHz 2GHz)
instractions_num=100000

bencmarks_makefiles=($(find $benchmarks_dir/ -iname Makefile))
#execute Makefiles
#for makefile in ${bencmarks_makefiles[*]}
#do
#    make -C $(dirname $makefile)/
#done

declare -A bencmarks_executable
bencmarks_executable[spec_cpu2006/401.bzip2/src/specbzip]="-o spec_cpu2006/401.bzip2/data/input.program 10"
bencmarks_executable[spec_cpu2006/429.mcf/src/specmcf]="-o spec_cpu2006/429.mcf/data/inp.in"
bencmarks_executable[spec_cpu2006/456.hmmer/src/spechmmer]="-o --fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm"
bencmarks_executable[spec_cpu2006/458.sjeng/src/specsjeng]="-o spec_cpu2006/458.sjeng/data/test.txt"
bencmarks_executable[spec_cpu2006/470.lbm/src/speclibm]="-o 20spec_cpu2006/470.lbm/data/lbm.in 0 1spec_cpu2006/470.lbm/data/100_100_130_cf_a.of"
bencmarks_name=(specbzip specmcf spechmmer specsjeng speclibm)
# -------------- l1 size benchmarks
i=0;
for bench in "${!bencmarks_executable[@]}"; do
  dirout="${bencmarks_name[$i]}"  #
  ((i+=1))
  for l1_data in ${l1_data_size[*]}; do
    for l1_instraction in ${l1_instraction_size[*]}; do
      $gem5_dir/build/ARM/gem5.opt -d ${benchmarks_output}/${dirout}/l1d.${l1_data}_l1i.${l1_instraction} $gem5_dir/configs/example/se.py --cpu-type=${cpu_types[0]} --caches --l2cache --l1d_size=$l1_data --l1i_size=$l1_instraction --l2_size=${l2_size[0]} --l1i_assoc=${l1_instraction_assoc[0]} --l1d_assoc=${l1_data_assoc[0]} --l2_assoc=${l2_data_assoc[0]} --cacheline_size=${caseline_size[0]} --cpu-clock=${cpu_clock[0]} -c $bench "${bencmarks_executable[$bench]}" -I $instractions_num
    done
  done
done
# -------------- l2_size benchmarks
i=0;
for bench in "${!bencmarks_executable[@]}"; do
  dirout="${bencmarks_name[$i]}"  #
  ((i+=1))
  for l2 in ${l2_size[*]}; do
      $gem5_dir/build/ARM/gem5.opt -d ${benchmarks_output}/${dirout}/l2_size.${l2} $gem5_dir/configs/example/se.py --cpu-type=${cpu_types[0]} --caches --l2cache --l1d_size=${l1_data_size[0]} --l1i_size=${l1_instraction_size[0]} --l2_size=$l2 --l1i_assoc=${l1_instraction_assoc[0]} --l1d_assoc=${l1_data_assoc[0]} --l2_assoc=${l2_data_assoc[0]} --cacheline_size=${caseline_size[0]} --cpu-clock=${cpu_clock[0]} -c $bench "${bencmarks_executable[$bench]}" -I $instractions_num
  done
done
# -------------- l1_instraction_assoc benchmarks
i=0;
for bench in "${!bencmarks_executable[@]}"; do
  dirout="${bencmarks_name[$i]}"  #
  ((i+=1))
  for l1i in ${l1_instraction_assoc[*]}; do
      $gem5_dir/build/ARM/gem5.opt -d ${benchmarks_output}/${dirout}/l1i_assoc.${l1i} $gem5_dir/configs/example/se.py --cpu-type=${cpu_types[0]} --caches --l2cache --l1d_size=${l1_data_size[0]} --l1i_size=${l1_instraction_size[0]} --l2_size=${l2_size[0]} --l1i_assoc=$l1i --l1d_assoc=${l1_data_assoc[0]} --l2_assoc=${l2_data_assoc[0]} --cacheline_size=${caseline_size[0]} --cpu-clock=${cpu_clock[0]} -c $bench "${bencmarks_executable[$bench]}" -I $instractions_num
  done
done
# -------------- l1_data_assoc benchmarks
i=0;
for bench in "${!bencmarks_executable[@]}"; do
  dirout="${bencmarks_name[$i]}"  #
  ((i+=1))
  for l1d in ${l1_data_assoc[*]}; do
      $gem5_dir/build/ARM/gem5.opt -d ${benchmarks_output}/${dirout}/l1d_assoc.${l1d} $gem5_dir/configs/example/se.py --cpu-type=${cpu_types[0]} --caches --l2cache --l1d_size=${l1_data_size[0]} --l1i_size=${l1_instraction_size[0]} --l2_size=${l2_size[0]} --l1i_assoc=${l1_instraction_assoc[0]} --l1d_assoc=$l1d --l2_assoc=${l2_data_assoc[0]} --cacheline_size=${caseline_size[0]} --cpu-clock=${cpu_clock[0]} -c $bench "${bencmarks_executable[$bench]}" -I $instractions_num
  done
done
# -------------- l2_data_assoc benchmarks
i=0;
for bench in "${!bencmarks_executable[@]}"; do
  dirout="${bencmarks_name[$i]}"  #
  ((i+=1))
  for l2d in ${l2_data_assoc[*]}; do
      $gem5_dir/build/ARM/gem5.opt -d ${benchmarks_output}/${dirout}/l2d_assoc.${l2d} $gem5_dir/configs/example/se.py --cpu-type=${cpu_types[0]} --caches --l2cache --l1d_size=${l1_data_size[0]} --l1i_size=${l1_instraction_size[0]} --l2_size=${l2_size[0]} --l1i_assoc=${l1_instraction_assoc[0]} --l1d_assoc=${l1_data_assoc[0]} --l2_assoc=$l2d --cacheline_size=${caseline_size[0]} --cpu-clock=${cpu_clock[0]} -c $bench "${bencmarks_executable[$bench]}" -I $instractions_num
  done
done
# -------------- caseline_size benchmarks
i=0;
for bench in "${!bencmarks_executable[@]}"; do
  dirout="${bencmarks_name[$i]}"  #
  ((i+=1))
  for csl in ${caseline_size[*]}; do
      $gem5_dir/build/ARM/gem5.opt -d ${benchmarks_output}/${dirout}/cacheline.${csl} $gem5_dir/configs/example/se.py --cpu-type=${cpu_types[0]} --caches --l2cache --l1d_size=${l1_data_size[0]} --l1i_size=${l1_instraction_size[0]} --l2_size=${l2_size[0]} --l1i_assoc=${l1_instraction_assoc[0]} --l1d_assoc=${l1_data_assoc[0]} --l2_assoc=${l2_data_assoc[0]} --cacheline_size=$csl --cpu-clock=${cpu_clock[0]} -c $bench "${bencmarks_executable[$bench]}" -I $instractions_num
  done
done
# -------------- cpu_clock benchmarks
i=0;
for bench in "${!bencmarks_executable[@]}"; do
  dirout="${bencmarks_name[$i]}"  #
  ((i+=1))
  for cpc in ${cpu_clock[*]}; do
      $gem5_dir/build/ARM/gem5.opt -d ${benchmarks_output}/${dirout}/cpu_clock.${cpc} $gem5_dir/configs/example/se.py --cpu-type=${cpu_types[0]} --caches --l2cache --l1d_size=${l1_data_size[0]} --l1i_size=${l1_instraction_size[0]} --l2_size=${l2_size[0]} --l1i_assoc=${l1_instraction_assoc[0]} --l1d_assoc=${l1_data_assoc[0]} --l2_assoc=${l2_data_assoc[0]} --cacheline_size=${caseline_size[0]} --cpu-clock=$cpc -c $bench "${bencmarks_executable[$bench]}" -I $instractions_num
  done
done

echo "Extracting Results"
echo "[Benchmarks]" > results_dirs
for i in $(ls ./Benchmarks_results/specbzip/); do echo ./Benchmarks_results/specbzip/$i >> results_dirs; done
echo "[Parameters]" >> results_dirs
echo "system.cpu.cpi" >> results_dirs
echo "[Output]" >> results_dirs
echo "Results_specbzip" >> results_dirs
./read_results results_dirs
