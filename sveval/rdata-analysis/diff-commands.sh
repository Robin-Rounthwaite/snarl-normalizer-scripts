diff-commmands.sh
# for both the sorted and unsorted diffs
diff sveval-hsvlr-unnormalized-HG002-nonrep-call.INS.TP-call.tsv sveval-hsvlr-normalized-HG002-nonrep-call.INS.TP-call.tsv sveval-hsvlr.unnorm-vs-norm.HG002-nonrep-call.INS.TP-call.unsorted-diff.txt
bash -c 'diff <(sort sveval-hsvlr-unnormalized-HG002-nonrep-call.INS.TP-call.tsv) <(sort sveval-hsvlr-normalized-HG002-nonrep-call.INS.TP-call.tsv) > sveval-hsvlr.unnorm-vs-norm.HG002-nonrep-call.INS.TP-call.diff.txt'

#for tp-baseline for del:
diff sveval-hsvlr-unnormalized-HG002-all-call.DEL.TP-baseline.tsv sveval-hsvlr-normalized-HG002-all-call.DEL.TP-baseline.tsv >sveval-hsvlr.unnorm-vs-norm.HG002-all-call.DEL.TP-baseline.unsorted-diff.txt
diff -y --suppress-common-lines sveval-hsvlr-unnormalized-HG002-all-call.DEL.TP-baseline.tsv sveval-hsvlr-normalized-HG002-all-call.DEL.TP-baseline.tsv > sveval-hsvlr.unnorm-vs-norm.HG002-all-call.DEL.TP-baseline.unsorted-diff.column.txt

#for tp-baseline for INS:
diff sveval-hsvlr-unnormalized-HG002-all-call.INS.TP-baseline.tsv sveval-hsvlr-normalized-HG002-all-call.INS.TP-baseline.tsv >sveval-hsvlr.unnorm-vs-norm.HG002-all-call.INS.TP-baseline.unsorted-diff.txt
diff -u sveval-hsvlr-unnormalized-HG002-all-call.INS.TP-baseline.tsv sveval-hsvlr-normalized-HG002-all-call.INS.TP-baseline.tsv >sveval-hsvlr.unnorm-vs-norm.HG002-all-call.INS.TP-baseline.unsorted-diff.unified.txt

#handy for counting diffs:
diff -y --suppress-common-lines sveval-hsvlr-unnormalized-HG002-all-call.INS.TP-baseline.tsv sveval-hsvlr-normalized-HG002-all-call.INS.TP-baseline.tsv > sveval-hsvlr.unnorm-vs-norm.HG002-all-call.INS.TP-baseline.unsorted-diff.column.txt