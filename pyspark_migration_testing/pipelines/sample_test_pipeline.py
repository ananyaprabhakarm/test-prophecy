from prophecy_pipeline_sdk.graph import *
from prophecy_pipeline_sdk.properties import *
args = PipelineArgs(label = "sample_test_pipeline", version = 1)

with Pipeline(args) as pipeline:
    sample_test_pipeline__age_group_analysis = Process(
        name = "sample_test_pipeline__age_group_analysis",
        properties = ModelTransform(modelName = "sample_test_pipeline__age_group_analysis")
    )
    sample_test_pipeline__reformat_people = Process(
        name = "sample_test_pipeline__reformat_people",
        properties = ModelTransform(modelName = "sample_test_pipeline__reformat_people")
    )
    sample_test_pipeline__sorted_countries = Process(
        name = "sample_test_pipeline__sorted_countries",
        properties = ModelTransform(modelName = "sample_test_pipeline__sorted_countries")
    )
    sample_test_pipeline__sorted_genders = Process(
        name = "sample_test_pipeline__sorted_genders",
        properties = ModelTransform(modelName = "sample_test_pipeline__sorted_genders")
    )
    xlsx_country_target = Process(
        name = "xlsx_country_target",
        properties = DatabricksVolumeTarget(
          compression = DatabricksVolumeTarget.Compression(kind = "uncompressed"),
          connector = "databricks",
          format = DatabricksVolumeTarget.XLSXWriteFormat(sheetName = "Country_Demographics"),
          properties = DatabricksVolumeTarget.DatabricksVolumeTargetInternal(
            filePath = "/Volumes/qa-team/qa_volume_managed/managed_volume/orchestration_datasets/xlsx/output/country_demographics.xlsx"
          )
        ),
        output_ports = None
    )
    xlsx_gender_target = Process(
        name = "xlsx_gender_target",
        properties = DatabricksVolumeTarget(
          compression = DatabricksVolumeTarget.Compression(kind = "uncompressed"),
          connector = "databricks",
          format = DatabricksVolumeTarget.XLSXWriteFormat(sheetName = "Gender_Analysis"),
          properties = DatabricksVolumeTarget.DatabricksVolumeTargetInternal(
            filePath = "/Volumes/qa-team/qa_volume_managed/managed_volume/orchestration_datasets/xlsx/output/gender_analysis.xlsx"
          )
        ),
        output_ports = None
    )
    xlsx_source = Process(
        name = "xlsx_source",
        properties = DatabricksVolumeSource(
          connector = "databricks",
          format = DatabricksVolumeSource.XLSXReadFormat(schema = "external_sources/sample_test_pipeline/xlsx_source.yml"),
          properties = DatabricksVolumeSource.DatabricksVolumeSourceInternal(
            fileOperationProperties = DatabricksVolumeSource.SourceFileOperation(includeFileNameColumn = False, includeSheetNameColumn = False),
            filePath = "/Volumes/qa-team/qa_volume_managed/managed_volume/orchestration_datasets/xlsx/file_example_XLSX_5000.xlsx"
          ),
          compression = DatabricksVolumeSource.Compression(kind = "uncompressed")
        ),
        input_ports = None,
        comment = "Imports employee records from an Excel file stored in Databricks."
    )
    sample_test_pipeline__sorted_countries >> xlsx_country_target
    sample_test_pipeline__sorted_genders >> xlsx_gender_target
    xlsx_source >> sample_test_pipeline__reformat_people
    (
        sample_test_pipeline__reformat_people._out(0)
        >> [sample_test_pipeline__age_group_analysis._in(0), sample_test_pipeline__sorted_countries._in(0),
              sample_test_pipeline__sorted_genders._in(0)]
    )
