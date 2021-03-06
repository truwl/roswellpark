cwlVersion: v1.0
class: CommandLineTool
baseCommand: configManta.py
requirements:
- class: DockerRequirement
  dockerPull: cmopipeline/strelka2_manta
- class: ShellCommandRequirement
arguments:
- --runDir
- mantaRunDir
- --exome
- valueFrom: ' && '
  position: 5
- valueFrom: mantaRunDir/runWorkflow.py
  position: 6
- valueFrom: -m
  position: 7
- valueFrom: local
  position: 8
inputs:
  tbam:
    type: File
    secondaryFiles: .bai
    inputBinding:
      position: 1
      prefix: --tumorBam
      separate: true
  nbam:
    type: File
    secondaryFiles: .bai
    inputBinding:
      position: 2
      prefix: --normalBam
      separate: true
  ref:
    type: File
    secondaryFiles: .fai
    inputBinding:
      position: 3
      prefix: --referenceFasta
      separate: true
  callRegions:
    type: File?
    secondaryFiles: .tbi
    inputBinding:
      position: 4
      prefix: --callRegions
      separate: true
outputs:
  somaticSV:
    type: File
    secondaryFiles: .tbi
    outputBinding:
      glob: mantaRunDir/results/variants/somaticSV.vcf.gz
  diploidSV:
    type: File
    secondaryFiles: .tbi
    outputBinding:
      glob: mantaRunDir/results/variants/diploidSV.vcf.gz
  candidateSV:
    type: File
    secondaryFiles: .tbi
    outputBinding:
      glob: mantaRunDir/results/variants/candidateSV.vcf.gz
  candidateSmallIndels:
    type: File
    secondaryFiles: .tbi
    outputBinding:
      glob: mantaRunDir/results/variants/candidateSmallIndels.vcf.gz
