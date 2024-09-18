cwlVersion: v1.1
class: CommandLineAgent
requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: crs4/slaid:1.1.0-beta.25-tissue_model-eddl_2-cudnn

  InitialWorkDirRequirement:
    listing:
      -  $(inputs.src)
baseCommand: [classify.py]
inputs:
  src:
    type: File
    inputBinding:
      position: 1
    secondaryFiles:
      - pattern: |-
          ${
            if (self.nameext == '.mrxs') {
              return {
              class: "Directory",
              location: self.location.match(/.*\//)[0] + "/" + self.nameroot,
              basename: self.nameroot};
            }
            else return null;
          }
        required: false
  level:
    type: int
    inputBinding:
      prefix: -l
  label:
    type: string
    inputBinding:
      prefix: -L
  filter_slide:
    type: File?
    inputBinding:
      prefix: --filter-slide
  filter:
    type: string?
    inputBinding:
      prefix: -F
  gpu:
    type: int?
    inputBinding:
      prefix: --gpu
  chunk-size:
    type: int?
  batch-size:
    type: int?

arguments: ["fixed-batch","-o", $(runtime.outdir), '--writer', 'zip']
outputs:
  tissue:
    type: File
    outputBinding:
      glob: '$(inputs.src.basename).zip'
      outputEval: ${self[0].basename=inputs.label + '.zip'; return self[0];}
