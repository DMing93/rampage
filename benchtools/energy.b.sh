#!/bin/bash

cat <<EOT
# Energy (autogenerated, do not edit!)

RESULTDIR=/home/ingo/memtester/results/energy-2012-09-02
EOT
. common.sh

energy restart RESET
echo "run sleep 10"
echo ""
echo "iterate 5000"

for bench in none kcompile pov iozone coremark; do
	echo "# ================= bench: $bench ================="
	for speed in none slow full burn; do
		echo "# ----------------- speed: $speed -----------------"
		FILENAME=energy-$bench-$speed
		if [ $speed = none ]; then
			# no claimer
			FILENAME=$FILENAME-none-"<ITERATION>"
			bench_init "no claimer"
			energy restart $FILENAME
			bench_run_infinite $bench $FILENAME
			energy takekwh $FILENAME
			bench_finish $FILENAME
		elif [ $speed = burn ]; then
			# no claimer but cpuburn
			FILENAME=$FILENAME-none-"<ITERATION>"
			bench_init "no claimer but cpuburn"
			echo "run <SCRIPTDIR>/start-cpuburn.sh"
			energy restart $FILENAME
			bench_run_infinite $bench $FILENAME
			energy takekwh $FILENAME
			bench_finish $FILENAME
		else
			for claimer in b bh bhs; do
				FILENAME_CLAIMER=$FILENAME-$claimer-"<ITERATION>"
				bench_init "claimer=$claimer"
				if [ $speed = slow ]; then
					MTARGS=MTARGS_SLOW
				elif [ $speed = full ]; then
					MTARGS=MTARGS_FULL
				else
					echo "WTF?" >&2
					exit 1
				fi
				memtester $FILENAME_CLAIMER $MTARGS $claimer
				energy restart $FILENAME_CLAIMER
				bench_run_infinite $bench $FILENAME_CLAIMER
				energy takekwh $FILENAME_CLAIMER
				bench_finish $FILENAME_CLAIMER
			done
		fi
	done
done

echo "enditer"
echo "reboot"