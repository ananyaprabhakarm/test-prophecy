from prophecy_pipeline_sdk.graph import *
from prophecy_pipeline_sdk.properties import *
args = PipelineArgs(label = "testing_runstoredprocedure", version = 1, auto_layout = False)

with Pipeline(args) as pipeline:
    runstoredprocedure_1 = Process(
        name = "RunStoredProcedure_1",
        properties = RunStoredProc(
          connectionType = "snowflake",
          connector = "snowflake_default",
          storedProcedure = "QA_DATABASE.QA_SCHEMA.test_add_numbers(5, 10)"
        ),
        input_ports = None
    )
    call_stored_proc = Process(
        name = "call_stored_proc",
        properties = CallStoredProc(
          parameters = {"a" : "NUM_A", "b" : "NUM_B"},
          passThroughColumns = [{"alias" : "ID", "expression" : {"expression" : "ID"}},
           {"alias" : "NUM_A", "expression" : {"expression" : "NUM_A"}},
           {"alias" : "NUM_B", "expression" : {"expression" : "NUM_B"}}],
          storedProcedureIdentifier = "QA_DATABASE.QA_SCHEMA.test_add_numbers"
        )
    )
    test_numbers_seed = Process(
        name = "test_numbers_seed",
        properties = Dataset(table = Dataset.DBTSource(name = "test_numbers", sourceType = "Seed")),
        input_ports = None
    )
    test_numbers_seed >> call_stored_proc
