from prophecy_pipeline_sdk.graph import *
from prophecy_pipeline_sdk.properties import *
args = PipelineArgs(label = "testing_runstoredprocedure", version = 1, auto_layout = False)

with Pipeline(args) as pipeline:
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
    run_stored_proc = Process(
        name = "run_stored_proc",
        properties = RunStoredProc(connectionType = "mssql", storedProcedure = "QA_DATABASE.QA_SCHEMA.test_add_numbers(5, 10)"),
        input_ports = None,
        comment = "Executes a stored procedure to add numbers in the QA database for automated data processing."
    )
    test_numbers_seed = Process(
        name = "test_numbers_seed",
        properties = Dataset(table = Dataset.DBTSource(name = "test_numbers", sourceType = "Seed")),
        input_ports = None
    )
    test_numbers_seed >> call_stored_proc
