# NUM_SHARDS="20"
# BIN_VERSION="1.5.0"
# docker run \
#   -u `id -u $USER` \
#   -v "/public/groups/vg":"/input" \
#   -v "/public/groups/vg/rrounthw/jean-combined-sv-graph/giraffe-mapping-full-genome:/output" \
#   google/deepvariant:"${BIN_VERSION}" \
#   /opt/deepvariant/bin/run_deepvariant \
#   --model_type=WGS \
#   --ref=/input/jmonlong/genome/hg38.fa \
#   --reads=/input/rrounthw/jean-combined-sv-graph/giraffe-mapping-full-genome/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.bam \
#   --output_vcf=/output/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.vcf \
#   --output_gvcf=/output/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.gvcf \
#   --num_shards=${NUM_SHARDS} \
#   --logging_dir=/output/normalized-logs \
#   --dry_run=false



# ###This is the most updated version of my command. It does the same as all the above, though.
# # NUM_SHARDS="20"
# # BIN_VERSION="1.5.0"
# # docker run \
# #   -v $(pwd):/input \
# #   google/deepvariant:"${BIN_VERSION}" \
# #   /opt/deepvariant/bin/run_deepvariant \
# #   --model_type="WGS" \
# #   --ref=/input/hg38.fa \
# #   --reads=/input/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.bam \
# #   --output_vcf=/input/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.vcf \
# #   --output_gvcf=/input/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.gvcf \
# #   --num_shards=${NUM_SHARDS} \
# #   --logging_dir=/input/ \
# #   --dry_run=false


nice samtools sort --threads 20 hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.bam > hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.sorted.bam
echo "done with sorting"
nice samtools index hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.sorted.bam > hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.sorted.bam.bai
echo "done with indexing"
mkdir norm-logs
NUM_SHARDS="20"
BIN_VERSION="1.5.0"
docker run \
  -u `id -u $USER` \
  -v $(pwd):/input \
  google/deepvariant:"${BIN_VERSION}" \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type="WGS" \
  --ref=/input/hg38.fa \
  --reads=/input/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.sorted.bam \
  --output_vcf=/input/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.main.vcf \
  --output_gvcf=/input/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.main.gvcf \
  --num_shards=${NUM_SHARDS} \
  --logging_dir=/input/norm-logs \
  --dry_run=false
