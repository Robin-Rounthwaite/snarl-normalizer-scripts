#junk:
                cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 && cd ~/paten_lab/vg-team/vg/test/tiny && time vg normalize -d tiny.dist -g tiny.gbwt -r tiny.gbwt.gg -t 1 -b -n 0 -u -o tiny.normalized.gbwt -s tiny.pg > tiny.segregated-regions.pg 2>tiny.stderr && 
                vg gbwt -P -o tiny.segregated-regions.gbwt -g tiny.segregated-regions.gbwt.gg -x tiny.segregated-regions.pg &&
                vg index -j tiny.segregated-regions.dist tiny.segregated-regions.pg &&
                time vg normalize -d tiny.segregated-regions.dist -g tiny.segregated-regions.gbwt -r tiny.segregated-regions.gbwt.gg -t 1 -b -n 0 -u -o tiny.segregated-regions.normalized.gbwt -s tiny.segregated-regions.pg > tiny.segregated-regions.normalized.pg 2>tiny.stderr && 
                vg view -dp tiny.segregated-regions.pg | dot -Tpdf -o tiny.segregated-regions.pdf &&
                echo "starting view" && vg view -dp tiny.segregated-regions.normalized.pg | dot -Tpdf -o tiny.segregated-regions.normalized.pdf && echo "done"


                # the following is broken unfortunately, since anytime I make a graph with an empty node (tiny-edited.single-base-shared-snarl-border.segregated-regions.pg), getting the distance index of that graph crashes.
                <!-- 
                cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 && cd ~/paten_lab/vg-team/vg/test/tiny && time vg normalize -d tiny-edited.single-base-shared-snarl-border.dist -g tiny-edited.single-base-shared-snarl-border.gbwt -r tiny-edited.single-base-shared-snarl-border.gbwt.gg -t 1 -b -n 0 -u -o tiny-edited.single-base-shared-snarl-border.normalized.gbwt -s tiny-edited.single-base-shared-snarl-border.pg > tiny-edited.single-base-shared-snarl-border.segregated-regions.pg 2>tiny.stderr && 
                vg gbwt -P -o tiny-edited.single-base-shared-snarl-border.segregated-regions.gbwt -g tiny-edited.single-base-shared-snarl-border.segregated-regions.gbwt.gg -x tiny-edited.single-base-shared-snarl-border.segregated-regions.pg &&
                vg index -j tiny-edited.single-base-shared-snarl-border.segregated-regions.dist tiny-edited.single-base-shared-snarl-border.segregated-regions.pg &&
                time vg normalize -d tiny-edited.single-base-shared-snarl-border.segregated-regions.dist -g tiny-edited.single-base-shared-snarl-border.segregated-regions.gbwt -r tiny-edited.single-base-shared-snarl-border.segregated-regions.gbwt.gg -t 1 -b -n 0 -u -o tiny-edited.single-base-shared-snarl-border.segregated-regions.normalized.gbwt -s tiny-edited.single-base-shared-snarl-border.segregated-regions.pg > tiny-edited.single-base-shared-snarl-border.segregated-regions.normalized.pg 2>tiny.stderr && 
                vg view -dp tiny-edited.single-base-shared-snarl-border.segregated-regions.pg | dot -Tpdf -o tiny-edited.single-base-shared-snarl-border.segregated-regions.pdf &&
                echo "starting view" && vg view -dp tiny-edited.single-base-shared-snarl-border.normalized.pg | dot -Tpdf -o tiny-edited.single-base-shared-snarl-border.normalized.pdf && echo "done" -->



                # here is a test for making a parallel reiongs only file:
                cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 && cd ~/paten_lab/vg-team/vg/test/tiny && 
                time vg normalize -d tiny.dist -g tiny.gbwt -r tiny.gbwt.gg -t 1 -b -n 0 -u -o tiny.normalized.gbwt -s test.segregated-regions-output.txt tiny.pg > tiny.segregated-regions.pg 2>tiny.stderr 


                time vg normalize -d tiny.dist -g tiny.gbwt -r tiny.gbwt.gg -t 1 -b -n 0 -u -o tiny.normalized.gbwt -s test.segregated-regions-output.txt tiny.pg > tiny.segregated-regions.pg 
                ##&&  vg gbwt -P -o tiny.segregated-regions.gbwt -g tiny.segregated-regions.gbwt.gg -x tiny.segregated-regions.pg && vg index -j tiny.segregated-regions.dist tiny.segregated-regions.pg && time vg normalize -d tiny.segregated-regions.dist -s test.segregated-regions-output.txt -g tiny.segregated-regions.gbwt -r tiny.segregated-regions.gbwt.gg -t 1 -n 0 -u -o tiny.segregated-regions.normalized.gbwt -s tiny.segregated-regions.pg > tiny.segregated-regions.normalized.pg 2>tiny.stderr


                cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 && cd ~/paten_lab/vg-team/vg/test/tiny &&
                time vg normalize -d tiny.dist -g tiny.gbwt -r tiny.gbwt.gg -t 1 -b -n 0 -u -o tiny.segregated-regions.gbwt -s test.segregated-regions-output.txt tiny.pg > tiny.segregated-regions.pg
vg normalize --run_tests -d graph.dist -g graph.gbwt -r graph.gbwt.gg -t 20 -n 32 --debug_print --run_tests graph.vg > graph.n32.segregated-regions.vg

#(i'm running this on mustard to adapt to pg, experiment to find out if I don't need to remake the gbwt:)
cd /private/groups/patenlab/rrounthw/vg &&
git pull && . ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
nice vg normalize --run_tests -d graph.dist -g graph.gbwt -r graph.gbwt.gg -t 20 -n 32 --debug_print --run_tests -o graph.n32.segregated-regions.pg.gbwt -s graph.n32.segregated-regions-data.pg.txt graph.pg > graph.n32.segregated-regions.pg
echo "DONE WITH INTERIM DATA, MOVING TO GBWT." &&
time vg gbwt -g graph.n32.segregated-regions.pg.gbwt.gg -x graph.n32.segregated-regions.pg graph.n32.segregated-regions.pg.gbwt &&
nice vg normalize --run_tests -d graph.dist -g graph.n32.segregated-regions.gbwt -r graph.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.n32.segregated-regions.normalized.gbwt -S graph.n32.segregated-regions-data.txt graph.n32.segregated-regions.pg > graph.n32.segregated-regions.normalized.pg



#not junk:
#for compile:
git add src/algorithms/0_move_embedded_paths_to_new_snarl.cpp  src/algorithms/0_oo_normalize_snarls.cpp &&
git commit -m "added print of number of regions to normalize" &&
git push

# experiment with segregated-regions intermediary.
cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 && cd ~/paten_lab/vg-team/vg/test/tiny &&
time vg normalize -d tiny.dist -g tiny.gbwt -r tiny.gbwt.gg -t 1 -n 0 --debug_print --run_tests -o tiny.segregated-regions.gbwt -s test.segregated-regions-output.txt tiny.pg > tiny.segregated-regions.pg &&
time vg gbwt -g tiny.segregated-regions.gbwt.gg -x tiny.segregated-regions.pg tiny.segregated-regions.gbwt &&
time vg normalize -g tiny.segregated-regions.gbwt -r tiny.segregated-regions.gbwt.gg -t 1 --debug_print --run_tests -n 0 -o tiny.segregated-regions.normalized.gbwt -S test.segregated-regions-output.txt tiny.segregated-regions.pg > tiny.segregated-regions.normalized.pg &&
vg view -dp tiny.segregated-regions.normalized.pg | dot -Tpdf -o tiny.segregated-regions.normalized.pdf

#for chr21 segregated-regions on local machine:
cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 && cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21-segregated-regions/ &&
vg normalize --run_tests -d graph.dist -g graph.n32.segregated-regions.gbwt -r graph.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.n32.segregated-regions.normalized.gbwt -S graph.n32.segregated-regions-data.txt graph.n32.segregated-regions.vg > graph.n32.segregated-regions.normalized.vg &


#for chr21 on mustard:
cd /private/groups/patenlab/rrounthw/vg &&
. ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
nice vg normalize --run_tests -d graph.dist -g graph.gbwt -r graph.gbwt.gg -t 20 -n 32 --debug_print --run_tests -o graph.n32.segregated-regions.gbwt -s graph.n32.segregated-regions-data.txt graph.pg > graph.n32.segregated-regions.pg
time vg gbwt -g graph.n32.segregated-regions.gbwt.gg -x graph.n32.segregated-regions.pg graph.n32.segregated-regions.gbwt &&
nice vg normalize --run_tests -d graph.dist -g graph.n32.segregated-regions.gbwt -r graph.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.n32.segregated-regions.normalized.gbwt -S graph.n32.segregated-regions-data.txt graph.n32.segregated-regions.pg > graph.n32.segregated-regions.normalized.pg

#for continuing chr21 on mustard:
cd /private/groups/patenlab/rrounthw/vg &&
git pull && . ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
nice vg normalize --run_tests -d graph.dist -g graph.n32.segregated-regions.gbwt -r graph.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.n32.segregated-regions.normalized.gbwt -S graph.n32.segregated-regions-data.txt graph.n32.segregated-regions.vg > graph.n32.segregated-regions.normalized.vg



# with one thread:
cd /private/groups/patenlab/rrounthw/vg &&
git pull && . ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
nice vg normalize --run_tests -d graph.dist -g graph.n32.segregated-regions.gbwt -r graph.n32.segregated-regions.gbwt.gg -t 1 -n 32 -o graph.n32.segregated-regions.normalized.gbwt -S graph.n32.segregated-regions-data.txt graph.n32.segregated-regions.vg > graph.n32.segregated-regions.normalized.vg

# for full genome:
cd /private/groups/patenlab/rrounthw/vg &&
git pull && . ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/ &&
nice vg normalize --run_tests -d nygc_snp1kg_grch38.new.dist -g nygc_snp1kg_grch38.all.gbwt -r nygc_snp1kg_grch38.gg -t 20 -n 32 --debug_print --run_tests -o nygc_snp1kg_grch38.n32.segregated-regions.gbwt -s nygc_snp1kg_grch38.n32.segregated-regions-data.txt nygc_snp1kg_grch38.pg > nygc_snp1kg_grch38.n32.segregated-regions.pg
time vg gbwt -g nygc_snp1kg_grch38.n32.segregated-regions.gbwt.gg -x nygc_snp1kg_grch38.n32.segregated-regions.vg nygc_snp1kg_grch38.n32.segregated-regions.gbwt &&
nice vg normalize --run_tests -g nygc_snp1kg_grch38.n32.segregated-regions.gbwt -r nygc_snp1kg_grch38.n32.segregated-regions.gbwt.gg -t 1 -n 32 -o nygc_snp1kg_grch38.n32.segregated-regions.normalized.gbwt -S nygc_snp1kg_grch38.n32.segregated-regions-data.txt nygc_snp1kg_grch38.n32.segregated-regions.vg > nygc_snp1kg_grch38.n32.segregated-regions.normalized.vg

-rw-r--r-- 1 rrounthw patenlab           0 Aug  4 12:52 nygc_snp1kg_grch38.normalized.pg
-rw-r--r-- 1 rrounthw patenlab 12444632423 Jun 26 17:34 nygc_snp1kg_grch38.pg
-rw-r--r-- 1 rrounthw patenlab 19126440841 Jun 26 14:56 nygc_snp1kg_grch38.all.gbwt
drwxr-sr-x 6 rrounthw patenlab         154 Jun 26 14:51 ..
-rw-r--r-- 1 rrounthw patenlab   340304859 Jun 26 14:48 nygc_snp1kg_grch38.snarls.pb
-rw-r--r-- 1 rrounthw patenlab 13737453235 May 18  2021 nygc_snp1kg_grch38.vg
-rw-r--r-- 1 rrounthw patenlab 14508436717 Mar 19  2021 nygc_snp1kg_grch38.new.dist
-rw-r--r-- 1 rrounthw patenlab  8501915547 Mar 19  2021 nygc_snp1kg_grch38.gg
-rw-r--r-- 1 rrounthw patenlab 27611457814 Mar 19  2021 nygc_snp1kg_grch38.min
-rw-r--r-- 1 rrounthw patenlab  4216178253 Mar 19  2021 nygc_snp1kg_grch38.N64-giraffe.gbwt


#for chr21 fix the gbwt:
echo "starting nice vg gbwt -x graph.pg -E -o graph.paths.gbwt " &&
nice vg gbwt -x graph.pg -E -o graph.paths.gbwt &&
echo "starting nice vg gbwt -m graph.gbwt graph.paths.gbwt -o graph.combined.gbwt " &&
nice vg gbwt -m graph.gbwt graph.paths.gbwt -o graph.combined.gbwt &&
echo "starting nice vg gbwt -g graph.combined.gbwt.gg -x graph.pg graph.combined.gbwt " &&
nice vg gbwt -g graph.combined.gbwt.gg -x graph.pg graph.combined.gbwt 


#for chr21 from beginning to end (and pg based):
cd /private/groups/patenlab/rrounthw/vg &&
git pull && . ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
nice vg normalize --run_tests -d graph.dist -g graph.gbwt -r graph.gbwt.gg -t 30 -n 32 -o graph.normalized.gbwt graph.pg > graph.n32.normalized.pg

#for full genome from beginning to end (and pg based):
cd /private/groups/patenlab/rrounthw/vg &&
. ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/ &&
echo "starting nice vg gbwt -x nygc_snp1kg_grch38.pg -E -o nygc_snp1kg_grch38.paths.gbwt " &&
nice vg gbwt -x nygc_snp1kg_grch38.pg -E -o nygc_snp1kg_grch38.paths.gbwt &&
echo "starting nice vg gbwt -m nygc_snp1kg_grch38.all.gbwt nygc_snp1kg_grch38.paths.gbwt -o nygc_snp1kg_grch38.combined.gbwt " &&
nice vg gbwt -m nygc_snp1kg_grch38.all.gbwt nygc_snp1kg_grch38.paths.gbwt -o nygc_snp1kg_grch38.combined.gbwt &&
echo "starting nice vg gbwt -g nygc_snp1kg_grch38.combined.gbwt.gg -x nygc_snp1kg_grch38.pg nygc_snp1kg_grch38.combined.gbwt " &&
nice vg gbwt -g nygc_snp1kg_grch38.combined.gbwt.gg -x nygc_snp1kg_grch38.pg nygc_snp1kg_grch38.combined.gbwt &&
echo "starting nice vg normalize --run_tests -d nygc_snp1kg_grch38.new.dist -g nygc_snp1kg_grch38.combined.gbwt -r nygc_snp1kg_grch38.combined.gbwt.gg -t 30 -n 32 -o nygc_snp1kg_grch38.combined.normalized.gbwt nygc_snp1kg_grch38.pg > nygc_snp1kg_grch38.n32.normalized.pg" &&
nice vg normalize --run_tests -d nygc_snp1kg_grch38.new.dist -g nygc_snp1kg_grch38.combined.gbwt -r nygc_snp1kg_grch38.combined.gbwt.gg -t 30 -n 32 -o nygc_snp1kg_grch38.combined.normalized.gbwt nygc_snp1kg_grch38.pg > nygc_snp1kg_grch38.n32.normalized.pg

#full genome after the proper gbwts have been made.
cd /private/groups/patenlab/rrounthw/vg &&
. ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/ &&
echo "starting vg normalize" &&
nice vg normalize --run_tests -d nygc_snp1kg_grch38.new.dist -g nygc_snp1kg_grch38.combined.gbwt -r nygc_snp1kg_grch38.combined.gbwt.gg -t 30 -n 32 -o nygc_snp1kg_grch38.combined.normalized.gbwt nygc_snp1kg_grch38.pg > nygc_snp1kg_grch38.n32.normalized.pg


#11/15/2023 
#for chr21 on mustard (gbwt is "combined," meaning it includes ref now):
cd /private/groups/patenlab/rrounthw/vg &&
git pull &&
. ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
# nice time vg normalize --run_tests -d graph.dist -g graph.combined.gbwt -r graph.combined.gbwt.gg -t 20 -n 32 --debug_print --run_tests -o graph.combined.n32.segregated-regions.gbwt -s graph.combined.n32.segregated-regions-data.txt graph.pg > graph.combined.n32.segregated-regions.pg
# nice time vg gbwt -g graph.combined.n32.segregated-regions.gbwt.gg -x graph.combined.n32.segregated-regions.pg graph.combined.n32.segregated-regions.gbwt &&
nice time vg normalize --run_tests -d graph.dist -g graph.combined.n32.segregated-regions.gbwt -r graph.combined.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.combined.n32.segregated-regions.normalized.gbwt -S graph.combined.n32.segregated-regions-data.txt graph.combined.n32.segregated-regions.pg > graph.combined.n32.segregated-regions.normalized.pg

#full genome but with the segregated-regions-data saved. (# git pull && git checkout robin-same-dist-normalize-regions && . ./source_me.sh && make -j 20 &&)
cd /private/groups/patenlab/rrounthw/vg &&
git checkout master && git pull && . ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/ &&
nice time vg normalize --run_tests -d nygc_snp1kg_grch38.new.dist -g nygc_snp1kg_grch38.combined.gbwt -r nygc_snp1kg_grch38.combined.gbwt.gg -t 20 -n 32 --debug_print --run_tests -o nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt -s nygc_snp1kg_grch38.combined.n32.segregated-regions-data.txt nygc_snp1kg_grch38.pg > nygc_snp1kg_grch38.combined.n32.segregated-regions.pg
nice time vg gbwt -g nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt.gg -x nygc_snp1kg_grch38.combined.n32.segregated-regions.pg nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt &&
nice time vg normalize --run_tests -g nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt -r nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o nygc_snp1kg_grch38.combined.n32.segregated-regions.normalized.gbwt -S nygc_snp1kg_grch38.combined.n32.segregated-regions-data.txt nygc_snp1kg_grch38.combined.n32.segregated-regions.pg > nygc_snp1kg_grch38.combined.n32.segregated-regions.normalized.pg


#11/16/2023:
# this is the same chr21 on mustard, but with the vg graph:
nice time vg normalize --run_tests -d graph.dist -g graph.combined.n32.segregated-regions.gbwt -r graph.combined.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.combined.n32.segregated-regions.normalized.for-vg.gbwt -S graph.combined.n32.segregated-regions-data.txt graph.n32.segregated-regions.vg > graph.combined.n32.segregated-regions.normalized.vg


#for when I'm running the chr21 locally:
cd ~/paten_lab/vg-team/vg/ &&
. ./source_me.sh && make -j 20 &&
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21-segregated-regions &&
nice time vg normalize --run_tests -d graph.dist -g graph.combined.n32.segregated-regions.gbwt -r graph.combined.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.combined.n32.segregated-regions.normalized.gbwt -S graph.n32.segregated-regions-data.txt graph.combined.n32.segregated-regions.pg > graph.combined.n32.segregated-regions.normalized.pg

#12/11/2023 
#for chr21 on mustard, using new gbwt and the segregated-regions versions of gbwt, graph, etc.. Also stderr is saved to a file.
cd /private/groups/patenlab/rrounthw/vg &&
git pull &&
. ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
echo "running normalize." &&
nice time vg normalize --run_tests -d graph.dist -g graph.combined.n32.segregated-regions.gbwt -r graph.combined.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.combined.n32.segregated-regions.normalized.gbwt -S graph.combined.n32.segregated-regions-data.txt graph.combined.n32.segregated-regions.pg > graph.combined.n32.segregated-regions.normalized.2.pg 2> graph.combined.n32.segregated-regions.normalized.2.stderr &&
echo "done"

#for chr21 on mustard with skip_desegregate, using new gbwt and the segregated-regions versions of gbwt, graph, etc.. Also stderr is saved to a file.
cd /private/groups/patenlab/rrounthw/vg &&
git pull &&
. ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/chr21 &&
echo "running normalize." &&
nice time vg normalize --skip_desegregate --run_tests -d graph.dist -g graph.combined.n32.segregated-regions.gbwt -r graph.combined.n32.segregated-regions.gbwt.gg -t 20 -n 32 -S graph.combined.n32.segregated-regions-data.txt graph.combined.n32.segregated-regions.pg > graph.combined.n32.segregated-regions.normalized.3.pg 2> graph.combined.n32.segregated-regions.normalized.3.stderr &&
echo "done"