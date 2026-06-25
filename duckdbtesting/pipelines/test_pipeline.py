from prophecy_pipeline_sdk.graph import *
from prophecy_pipeline_sdk.properties import *
args = PipelineArgs(label = "test_pipeline", version = 1)

with Pipeline(args) as pipeline:
    test_pipeline__by_category_groupby_002 = Process(
        name = "test_pipeline__by_category_groupBy_002",
        properties = ModelTransform(modelName = "test_pipeline__by_category_groupBy_002"),
        input_ports = ["in_0", "in_1"]
    )
    test_pipeline__by_region_groupby_002 = Process(
        name = "test_pipeline__by_region_groupBy_002",
        properties = ModelTransform(modelName = "test_pipeline__by_region_groupBy_002"),
        input_ports = ["in_0", "in_1"]
    )
    test_pipeline__enriched_data = Process(
        name = "test_pipeline__enriched_data",
        properties = ModelTransform(modelName = "test_pipeline__enriched_data")
    )
    test_pipeline__overall_stats = Process(
        name = "test_pipeline__overall_stats",
        properties = ModelTransform(modelName = "test_pipeline__overall_stats")
    )
    test_pipeline__sample_data = Process(
        name = "test_pipeline__sample_data",
        properties = ModelTransform(modelName = "test_pipeline__sample_data"),
        input_ports = None
    )
    (
        test_pipeline__sample_data._out(0)
        >> [test_pipeline__by_category_groupby_002._in(0), test_pipeline__by_category_groupby_002._in(1),
              test_pipeline__by_region_groupby_002._in(0), test_pipeline__by_region_groupby_002._in(1),
              test_pipeline__enriched_data._in(0), test_pipeline__overall_stats._in(0)]
    )
