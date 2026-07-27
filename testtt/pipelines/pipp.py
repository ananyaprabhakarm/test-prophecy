from prophecy_pipeline_sdk.graph import *
from prophecy_pipeline_sdk.properties import *
args = PipelineArgs(label = "pipp", version = 1, auto_layout = False)

with Pipeline(args) as pipeline:
    orchestrationtarget_1 = Process(
        name = "OrchestrationTarget_1",
        properties = SharepointTarget(
          format = SharepointTarget.CsvWriteFormat(),
          compression = SharepointTarget.Compression(kind = "uncompressed"),
          properties = SharepointTarget.SharepointTargetInternal(),
          connector = {"kind" : "sharepoint", "properties" : {}, "type" : "connector"}
        ),
        output_ports = None
    )
    orchestrationtarget_2 = Process(
        name = "OrchestrationTarget_2",
        properties = SharepointTarget(
          connector = {"kind" : "sharepoint", "properties" : {}, "type" : "connector"},
          properties = SharepointTarget.SharepointTargetInternal(),
          format = SharepointTarget.CsvWriteFormat()
        ),
        output_ports = None
    )
    pipp__dataencoderdecoder_1 = Process(
        name = "pipp__DataEncoderDecoder_1",
        properties = ModelTransform(modelName = "pipp__DataEncoderDecoder_1"),
        input_ports = None
    )
    pipp__unpivot_1 = Process(
        name = "pipp__Unpivot_1",
        properties = ModelTransform(modelName = "pipp__Unpivot_1"),
        input_ports = None
    )
    qa_table = Process(
        name = "qa_table",
        properties = Dataset(
          writeOptions = {"writeMode" : "overwrite"},
          table = Dataset.DBTSource(name = "qa_table", sourceName = "qa_team_qa_database", sourceType = "Table")
        )
    )
    qa_table >> orchestrationtarget_1
