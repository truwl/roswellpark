cwlVersion: v1.0
class: CommandLineTool
baseCommand: configureStrelkaSomaticWorkflow.py
requirements:
- class: DockerRequirement
  dockerPull: cmopipeline/strelka2_manta
- class: ShellCommandRequirement
arguments:
- --runDir
- strelkaRunDir
- --exome
- valueFrom: ' && '
  position: 6
- valueFrom: strelkaRunDir/runWorkflow.py
  position: 7
- valueFrom: -m
  position: 8
- valueFrom: local
  position: 9
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
  indelCandidates:
    type: File?
    inputBinding:
      position: 5
      prefix: --indelCandidates
      separate: true
outputs:
  snvs:
    type: File
    secondaryFiles: .tbi
    outputBinding:
      glob: strelkaRunDir/results/variants/somatic.snvs.vcf.gz
  indels:
    type: File
    secondaryFiles: .tbi
    outputBinding:
      glob: strelkaRunDir/results/variants/somatic.indels.vcf.gz
