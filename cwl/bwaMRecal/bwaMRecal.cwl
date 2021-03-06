cwlVersion: v1.0
class: Workflow
requirements:
- class: SubworkflowFeatureRequirement
- class: StepInputExpressionRequirement
inputs:
  outBam:
    type: string
  RG:
    type: string
  threads:
    type: int
  Ref:
    type: File
    secondaryFiles:
    - .amb
    - .ann
    - .bwt
    - .pac
    - .sa
    - .fai
    - $(self.nameroot).dict
  FQ1s:
    type: File
  FQ2s:
    type: File
  knowSites:
    type:
      type: array
      items: File
      inputBinding:
        separate: true
    secondaryFiles: .idx
outputs:
  BAM:
    type: File
    outputSource: BaseRecal/rcBam
  matrix:
    type: File
    outputSource: markdup/Mat
  flagstat:
    type: File
    outputSource: BaseRecal/flagstat
  stats:
    type: File
    outputSource: BaseRecal/stats
steps:
  bwaAlign:
    run: cwl/bwaMRecal/bwaAlign.cwl
    in:
      threads: threads
      RG: RG
      Ref: Ref
      FQ1: FQ1s
      FQ2: FQ2s
    out:
    - Bam
    - Idx
  markdup:
    run: cwl/bwaMRecal/markdup.cwl
    in:
      ibam: bwaAlign/Idx
      obam:
        valueFrom: $(inputs.ibam.nameroot).mdup.bam
      matrix:
        source:
        - outBam
        valueFrom: $(self).markdup.txt
    out:
    - mBam
    - Mat
  BaseRecal:
    run: cwl/bwaMRecal/BaseRecal.cwl
    in:
      bam: markdup/mBam
      ref: Ref
      knowSites: knowSites
      oBam: outBam
    out:
    - rcBam
    - flagstat
    - stats
